with joined_data as (
    select
        t.PROJECT_ID        as "פרויקט_ID",
        t.BUD_CONTROL_DATE  as "Date",
        t.SOURCE_DB         as "חברה",
        case when cc."מקור" = 'אגף ביצוע' then 'העמסת אגף ביצוע'
             when cc."מקור" = 'תיקוני בדק ואחריות' then 'בדק ואחריות' 
             when cc."מקור" = 'כלליות' then 'סך הוצ כלליות' 
             when cc."מקור" = 'ישירות' then 'סך הוצ ישירות' else cc."מקור" end as "מקור",
        t.FORECAST_TO_COMPLETE_K as "אומדן לגמר (הוצאות) באלפי שח",
        t.CURRENT_BUDGET_K       as "תקציב הוצאות עדכני באלפי שח",
        t.PREVIOUS_FORECAST_K    as "אומדן קודם (הוצאות) באלפי שח",
        t.ORIGINAL_BUDGET_K      as "תקציב הוצאות מקורי באלפי שח"
    from {{ ref('PROJ_BUD_EXP_FORECAST_STG') }} t

    left join {{ ref('DIM_SUBCHAPTERS_V_Budget_Control') }} cc
        on coalesce(t.SUB_CHAPTER_NAME, 'ללא') = cc."מספר תת פרק"
        and t.SOURCE_DB = cc."חברה"

    {{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}
),

--הוצאות
expense_agg as (
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        sum("אומדן לגמר (הוצאות) באלפי שח") as "אומדן לגמר (הוצאות) באלפי שח",
        sum("תקציב הוצאות עדכני באלפי שח")  as "תקציב הוצאות עדכני באלפי שח",
        sum("אומדן קודם (הוצאות) באלפי שח") as "אומדן קודם (הוצאות) באלפי שח",
        sum("תקציב הוצאות מקורי באלפי שח")  as "תקציב הוצאות מקורי באלפי שח"
    from joined_data
    group by "פרויקט_ID", "Date", "חברה", "מקור"
),

-- חישוב העמסת אגף ביצוע
execution_overhead_agg as (
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        'העמסת אגף ביצוע' as "מקור",
        sum(case when "מקור" in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות')
                then "אומדן לגמר (הוצאות) באלפי שח" else 0 end) * 0.0125 as "אומדן לגמר (הוצאות) באלפי שח",

        sum(case when "מקור" in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות')
                then "תקציב הוצאות עדכני באלפי שח" else 0 end) * 0.0125 as "תקציב הוצאות עדכני באלפי שח",

        sum(case when "מקור" in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות')
                then "אומדן קודם (הוצאות) באלפי שח" else 0 end) * 0.0125 as "אומדן קודם (הוצאות) באלפי שח",

        sum(case when "מקור" in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות')
                then "תקציב הוצאות מקורי באלפי שח" else 0 end) * 0.0125 as "תקציב הוצאות מקורי באלפי שח"
    from expense_agg
    group by
        "פרויקט_ID",
        "Date",
        "חברה"
),

--הכנסות
revenue_agg as (
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        sum("אומדן לגמר (הכנסות) באלפי שח") as "אומדן לגמר (הכנסות) באלפי שח",
        sum("תקציב הכנסות עדכני באלפי שח")  as "תקציב הכנסות עדכני באלפי שח",
        sum("אומדן קודם (הכנסות) באלפי שח") as "אומדן קודם (הכנסות) באלפי שח",
        sum("תקציב הכנסות מקורי באלפי שח")  as "תקציב הכנסות מקורי באלפי שח"
    from {{ ref('PROJ_BUD_INC_FORECAST_V') }}
    group by "פרויקט_ID", "Date","חברה"
),

--טבלה סופית
final_table_temp as(

// ==========================
// הוצאות
// ==========================

select
    "פרויקט_ID",
    "Date",
    "חברה",
    "מקור",
    "אומדן לגמר (הוצאות) באלפי שח" as "אומדן נוכחי",
    "תקציב הוצאות עדכני באלפי שח" as "מעודכן", --תקציב מעודכן
    "אומדן קודם (הוצאות) באלפי שח" as "אומדן קודם",
    "תקציב הוצאות מקורי באלפי שח" as "אפס" --תקציב אפס
from expense_agg

union all

// ==========================
// הכנסות
// ==========================

select
    "פרויקט_ID",
    "Date",
    "חברה",
    'סך הכנסות' as "מקור",
    "אומדן לגמר (הכנסות) באלפי שח" as "אומדן נוכחי",
    "תקציב הכנסות עדכני באלפי שח" as "מעודכן", --תקציב מעודכן
    "אומדן קודם (הכנסות) באלפי שח" as "אומדן קודם",
    "תקציב הכנסות מקורי באלפי שח" as "אפס" --תקציב אפס
from revenue_agg
where "מקור" <> 'העמסת אגף ביצוע'
),

--רווח גולמי
gross_profit_agg as (
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        'רווח גולמי' as "מקור",
        sum(case when "מקור" = 'סך הכנסות' then "אומדן נוכחי"
                 when "מקור" in ('סך הוצ ישירות', 'סך הוצ כלליות', 'בצ"מ', 'בדק ואחריות')
                    then -"אומדן נוכחי" else 0 end) as "אומדן נוכחי",

        sum(case when "מקור" = 'סך הכנסות' then "מעודכן"
                 when "מקור" in ('סך הוצ ישירות', 'סך הוצ כלליות', 'בצ"מ', 'בדק ואחריות')
                    then -"מעודכן" else 0 end) as "מעודכן",

        sum(case when "מקור" = 'סך הכנסות' then "אומדן קודם" 
                 when "מקור" in ('סך הוצ ישירות', 'סך הוצ כלליות', 'בצ"מ', 'בדק ואחריות')
                    then -"אומדן קודם" else 0 end) as "אומדן קודם",

        sum(case when "מקור" = 'סך הכנסות' then "אפס" 
                 when "מקור" in ('סך הוצ ישירות', 'סך הוצ כלליות', 'בצ"מ', 'בדק ואחריות')
                    then -"אפס" else 0 end) as "אפס"
from final_table_temp
    group by
        "פרויקט_ID",
        "Date",
        "חברה"
        )

--אחוז רווח גולמי מההכנסות
,gross_profit_pct as (
    select
        gp."פרויקט_ID",
        gp."Date",
        gp."חברה",
        'אחוז רווח גולמי מההכנסות' as "מקור",
        gp."אומדן נוכחי" / nullif(r."אומדן נוכחי", 0) as "אומדן נוכחי",
        gp."מעודכן" / nullif(r."מעודכן", 0) as "מעודכן",
        gp."אומדן קודם" / nullif(r."אומדן קודם", 0) as "אומדן קודם",
        gp."אפס" / nullif(r."אפס", 0) as "אפס"
    from gross_profit_agg gp
    left join final_table_temp r
        on gp."פרויקט_ID" = r."פרויקט_ID"
        and gp."Date" = r."Date"
        and gp."חברה" = r."חברה"
        and r."מקור" = 'סך הכנסות'
)

--רווח (הפסד) - רווח גולמי פחות ביצוע
,profit_loss as (
    select
        gp."פרויקט_ID",
        gp."Date",
        gp."חברה",
        'רווח (הפסד)' as "מקור",
        gp."אומדן נוכחי" - coalesce(eo."אומדן נוכחי", 0) as "אומדן נוכחי",
        gp."מעודכן" - coalesce(eo."מעודכן", 0) as "מעודכן",
        gp."אומדן קודם" - coalesce(eo."אומדן קודם", 0) as "אומדן קודם",
        gp."אפס" - coalesce(eo."אפס", 0) as "אפס"
    from gross_profit_agg gp
left join final_table_temp eo
        on gp."פרויקט_ID" = eo."פרויקט_ID"
        and gp."Date" = eo."Date"
        and gp."חברה" = eo."חברה"
        and eo."מקור" = 'העמסת אגף ביצוע'
)

--שיעור רווחיות
,profitability_pct as (
    select
        pl."פרויקט_ID",
        pl."Date",
        pl."חברה",
        'שיעור רווחיות' as "מקור",
        pl."אומדן נוכחי" / nullif(r."אומדן נוכחי", 0) as "אומדן נוכחי",
        pl."מעודכן" / nullif(r."מעודכן", 0) as "מעודכן",
        pl."אומדן קודם" / nullif(r."אומדן קודם", 0) as "אומדן קודם",
        pl."אפס" / nullif(r."אפס", 0) as "אפס"
    from profit_loss pl
left join final_table_temp r
        on pl."פרויקט_ID" = r."פרויקט_ID"
        and pl."Date" = r."Date"
        and pl."חברה" = r."חברה"
        and r."מקור" = 'סך הכנסות'
)

,all_rows as (
    select * from final_table_temp
    union all
    select * from gross_profit_agg
    union all
    select * from gross_profit_pct
    union all
    select * from profit_loss
    union all
    select * from profitability_pct
)

--טבלת חישובים (שינוי מאומדן, שינוי מתקציב, אחוז שינוי)
,calc_changes as (
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        case "מקור"
            when 'סך הכנסות' then 1
            when 'סך הוצ ישירות' then 2
            when 'סך הוצ כלליות' then 3
            when 'בצ"מ' then 4
            when 'בדק ואחריות' then 5
            when 'רווח גולמי' then 6
            when 'אחוז רווח גולמי מההכנסות' then 7
            when 'העמסת אגף ביצוע' then 8
            when 'רווח (הפסד)' then 9
            when 'שיעור רווחיות' then 10
            else 99
        end as "סדר מקור",
        "אפס",
        "מעודכן",
        "אומדן קודם",
        "אומדן נוכחי" - "אומדן קודם" as "שינוי מאומדן קודם",
        "אומדן נוכחי",
        "אומדן נוכחי" - "מעודכן" as "שינוי ממעודכן",
        ("אומדן נוכחי" - "מעודכן") / nullif("מעודכן", 0) as "אחוז שינוי ממעודכן"
    from all_rows
)

-- יעדי הנהלה
,management_targets as (

    select
        "פרויקט_ID",
        "מספר פרויקט",
        "מקור",
        "יעד ההנהלה"
    from {{ source('csv', 'MANAGEMENT_TARGET') }}
)

--טבלה סופית עם מיון
,final_long as (
    -- =====================
    -- תקציב
    -- =====================
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        "סדר מקור",
        'תקציב' as "כותרת",
        'אפס' as "תת כותרת",
        "אפס" as "ערך",
        1 as "סדר כותרת",
        1 as "סדר תת כותרת"
    from calc_changes

    union all

    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        "סדר מקור",
        'תקציב' as "כותרת",
        'מעודכן' as "תת כותרת",
        "מעודכן" as "ערך",
        1 as "סדר כותרת",
        2 as "סדר תת כותרת"
    from calc_changes

    
    union all

-- =====================
-- יעד הנהלה (ברמת פרויקט ולא חודש)
-- =====================
select
    c."פרויקט_ID",
    c."Date",
    c."חברה",
    c."מקור",
    c."סדר מקור",
    'יעד ההנהלה' as "כותרת",
    ' ' as "תת כותרת",
    mt."יעד ההנהלה" as "ערך",
    2 as "סדר כותרת",
    3 as "סדר תת כותרת"
from calc_changes c
left join management_targets mt
    on c."פרויקט_ID" = mt."פרויקט_ID"
--    and date_trunc('month', c."Date") = mt."חודש"
    and c."מקור" = mt."מקור"

    union all

    -- =====================
    -- תחזית לגמר פרויקט
    -- =====================
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        "סדר מקור",
        'תחזית לגמר פרויקט' as "כותרת",
        'אומדן קודם' as "תת כותרת",
        "אומדן קודם" as "ערך",
        3 as "סדר כותרת",
        4 as "סדר תת כותרת"
    from calc_changes

    union all

    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        "סדר מקור",
        'תחזית לגמר פרויקט' as "כותרת",
        'שינוי' as "תת כותרת",
        "שינוי מאומדן קודם" as "ערך",
        3 as "סדר כותרת",
        5 as "סדר תת כותרת"
    from calc_changes

    union all

    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        "סדר מקור",
        'תחזית לגמר פרויקט' as "כותרת",
        'אומדן נוכחי' as "תת כותרת",
        "אומדן נוכחי" as "ערך",
        3 as "סדר כותרת",
        6 as "סדר תת כותרת"
    from calc_changes

    union all

    -- =====================
    -- לעומת תקציב מעודכן
    -- =====================
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        "סדר מקור",
        'לעומת תקציב מעודכן' as "כותרת",
        'שינוי' as "תת כותרת",
        "שינוי ממעודכן" as "ערך",
        4 as "סדר כותרת",
        7 as "סדר תת כותרת"
    from calc_changes

    union all

    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        "סדר מקור",
        'לעומת תקציב מעודכן' as "כותרת",
        '%' as "תת כותרת",
        "אחוז שינוי ממעודכן" as "ערך",
        4 as "סדר כותרת",
        8 as "סדר תת כותרת"
    from calc_changes
)

select 
    "פרויקט_ID",
    "Date",
    "חברה",
    "מקור" as "מקור-דוח",
    "סדר מקור",
    "כותרת",
    "תת כותרת",
    "ערך",
    "סדר כותרת",
    "סדר תת כותרת"
from final_long
where "מקור" <> 'לא מסווג'