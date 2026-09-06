with joined_data as (
select
        t.PROJECT_NAME as "מספר פרויקט",
        t.PROJECT_ID   as "פרויקט_ID",
        date_trunc('month', t.BUD_CONTROL_DATE) as "Date",
        t.SOURCE_DB as "חברה",
        coalesce(t.SUB_CHAPTER_NAME, 'ללא') as "מספר תת פרק",
        case when cc."מקור" = 'אגף ביצוע' then 'העמסת אגף ביצוע'
             when cc."מקור" = 'תיקוני בדק ואחריות' then 'בדק ואחריות'
             when cc."מקור" = 'כלליות' then 'סך הוצ כלליות'
             when cc."מקור" = 'ישירות' then 'סך הוצ ישירות'
            else cc."מקור" end as "מקור",
        t.FORECAST_TO_COMPLETE_K as "אומדן לגמר (הוצאות) באלפי שח",
        t.CURRENT_BUDGET_K as "תקציב הוצאות עדכני באלפי שח",
        t.PREVIOUS_FORECAST_K as "אומדן קודם (הוצאות) באלפי שח",
        t.ORIGINAL_BUDGET_K as "תקציב הוצאות מקורי באלפי שח"
from {{ ref('PROJ_BUD_EXP_FORECAST_STG') }} t

left join {{ ref('DIM_SUBCHAPTERS_V_Budget_Control') }} cc
     on coalesce(t.SUB_CHAPTER_NAME, 'ללא') = cc."מספר תת פרק"
     and t.SOURCE_DB = cc."חברה"

{{ join_bst_projects_budget_control('PROJECT_NAME','t.SOURCE_DB') }}),

-- סיכום הוצאות הבסיס (ללא אגף ביצוע) לפי פרויקט וחודש, כאשר אומדן נוכחי וקודם מחושבים ללא תת פרק 991
expense_base as (
    select
        "מספר פרויקט",
        "Date",
        "חברה",
        sum(coalesce("תקציב הוצאות מקורי באלפי שח",0)) as "אפס בסיס",
        sum(coalesce("תקציב הוצאות עדכני באלפי שח",0)) as "מעודכן בסיס",
        sum(case when "מספר תת פרק" <> '991' then coalesce("אומדן קודם (הוצאות) באלפי שח",0) else 0 end) as "אומדן קודם בסיס",
        sum(case when "מספר תת פרק" <> '991' then coalesce("אומדן לגמר (הוצאות) באלפי שח",0) else 0 end) as "אומדן נוכחי בסיס"
    from joined_data
    where "מקור" in (
        'סך הוצ ישירות',
        'סך הוצ כלליות',
        'בצ"מ',
        'בדק ואחריות')
    group by
        "מספר פרויקט",
        "Date",
        "חברה"
),

-- חישוב העמסת אגף ביצוע בשיעור 1.25% מתוך הוצאות ישירות, כלליות ובדק ואחריות
execution_overhead as (
    select
        "מספר פרויקט",
        "Date",
        "חברה",
        sum(case when "מקור" in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות')
                then coalesce("תקציב הוצאות מקורי באלפי שח",0) else 0 end) * 0.0125 as "אפס אגף ביצוע",
        sum(case when "מקור" in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות')
                then coalesce("תקציב הוצאות עדכני באלפי שח",0) else 0 end) * 0.0125 as "מעודכן אגף ביצוע",

        sum(case when "מקור" in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות') and "מספר תת פרק" <> '991'
                then coalesce("אומדן קודם (הוצאות) באלפי שח",0) else 0 end) * 0.0125 as "אומדן קודם אגף ביצוע",
        sum(case when "מקור" in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות') and "מספר תת פרק" <> '991'
                then coalesce("אומדן לגמר (הוצאות) באלפי שח",0) else 0 end) * 0.0125 as "אומדן נוכחי אגף ביצוע"
    from joined_data
    group by
        "מספר פרויקט",
        "Date",
        "חברה"
),

-- שורת ההתייקרות - תת פרק 991 בלבד
escalation as (
    select
        "מספר פרויקט",
        "Date",
        "חברה",
        sum(coalesce("אומדן קודם (הוצאות) באלפי שח",0)) as "אומדן קודם",
        sum(coalesce("אומדן לגמר (הוצאות) באלפי שח",0)) as "אומדן נוכחי"
    from joined_data
    where "מספר תת פרק" = '991'
    group by
        "מספר פרויקט",
        "פרויקט_ID",
        "Date",
        "חברה"
),

-- יעדי הנהלה
management_targets as (
    select
        "מספר פרויקט",
        sum(case when "מקור" in (
                    'סך הוצ ישירות',
                    'סך הוצ כלליות',
                    'בצ"מ',
                    'בדק ואחריות',
                    'העמסת אגף ביצוע'
                ) then coalesce("יעד ההנהלה", 0) else 0 end) as "יעד הנהלה"
    from {{ source('csv', 'MANAGEMENT_TARGET') }}

    group by "מספר פרויקט"
),

-- שורת ריכוז ההוצאות באמצעות חיבור הוצאות הבסיס עם העמסת אגף ביצוע ויעד ההנהלה
expense_summary_row as (
    select
        e."מספר פרויקט",
        e."Date",
        e."חברה",
        'ריכוז הוצ'' (כולל אגף ביצוע) - מדד בסיס' as "מרכיבי אומדן הוצאות",
        coalesce(e."אפס בסיס", 0) + coalesce(o."אפס אגף ביצוע", 0) as "תקציב אפס",
        coalesce(e."מעודכן בסיס", 0) + coalesce(o."מעודכן אגף ביצוע", 0) as "תקציב מעודכן",
        coalesce(mt."יעד הנהלה", 0) as "יעד הנהלה",
        coalesce(e."אומדן קודם בסיס", 0) + coalesce(o."אומדן קודם אגף ביצוע", 0) as "דו''ח קודם",
        coalesce(e."אומדן נוכחי בסיס", 0) + coalesce(o."אומדן נוכחי אגף ביצוע", 0) as "דו''ח נוכחי",
        1 as "סדר מיון"
    from expense_base e

    left join execution_overhead o
        on e."חברה" = o."חברה"
        and e."מספר פרויקט" = o."מספר פרויקט"
        and e."Date" = o."Date"

    left join management_targets mt
        on e."מספר פרויקט" = mt."מספר פרויקט"
),

-- בניית שורת ההתייקרות ללא תקציב ויעד הנהלה, על בסיס נתוני תת פרק 991
escalation_row as (
    select
        e."מספר פרויקט",
        e."Date",
        e."חברה",
        'התייקרות' as "מרכיבי אומדן הוצאות",
        0 as "תקציב אפס",
        0 as "תקציב מעודכן",
        0 as "יעד הנהלה",
        coalesce(x."אומדן קודם", 0) as "דו''ח קודם",
        coalesce(x."אומדן נוכחי", 0) as "דו''ח נוכחי",
        2 as "סדר מיון"
    from expense_base e

    left join escalation x
        on e."חברה" = x."חברה"
        and e."מספר פרויקט" = x."מספר פרויקט"
        and e."Date" = x."Date"
),


--איחוד 2 שורות הדוח
final_result as (
    select * from expense_summary_row
    union all
    select * from escalation_row
)


select
    "מספר פרויקט",
    "Date",
    "חברה",
    "מרכיבי אומדן הוצאות",
    "תקציב אפס",
    "תקציב מעודכן",
    "יעד הנהלה",
    "דו''ח קודם",
    "דו''ח נוכחי" - "דו''ח קודם" as "שינוי מדו''ח קודם",
    "דו''ח נוכחי",
    "סדר מיון"
from final_result