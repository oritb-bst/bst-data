with joined_data as (

    select
        t.PROJECT_ID        as "פרויקט_ID",
        t.BUD_CONTROL_DATE  as "Date",
        t.SOURCE_DB         as "חברה",
        coalesce(cc."מקור", 'לא מסווג') as "מקור",
        t.FORECAST_TO_COMPLETE as "אומדן לגמר (הוצאות)",
        t.CURRENT_BUDGET       as "תקציב הוצאות עדכני",
        t.PREVIOUS_FORECAST    as "אומדן קודם (הוצאות)",
        t.ORIGINAL_BUDGET      as "תקציב הוצאות מקורי"

    from {{ ref('PROJ_BUD_EXP_FORECAST_STG') }} t

    left join {{ ref('DIM_SUBCHAPTERS_V_Budget_Control') }} cc
        on coalesce(t.SUB_CHAPTER_NAME, 'ללא') = cc."מספר תת פרק"
        and t.SOURCE_DB = cc."חברה"

    {{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}
),

expense_agg as (
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        "מקור",
        sum("אומדן לגמר (הוצאות)") as "אומדן לגמר (הוצאות)",
        sum("תקציב הוצאות עדכני")  as "תקציב הוצאות עדכני",
        sum("אומדן קודם (הוצאות)") as "אומדן קודם (הוצאות)",
        sum("תקציב הוצאות מקורי")  as "תקציב הוצאות מקורי"
    from joined_data
    group by "פרויקט_ID", "Date", "חברה", "מקור"
),

revenue_agg as (
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        sum("אומדן לגמר (הכנסות)") as "אומדן לגמר (הכנסות)",
        sum("תקציב הכנסות עדכני")  as "תקציב הכנסות עדכני",
        sum("אומדן קודם (הכנסות)") as "אומדן קודם (הכנסות)",
        sum("תקציב הכנסות מקורי")  as "תקציב הכנסות מקורי"
    from {{ ref('PROJ_BUD_INC_FORECAST_V') }}
    group by "פרויקט_ID", "Date","חברה"
),

final_table_temp as(

// ==========================
// הוצאות
// ==========================

select
    "פרויקט_ID",
    "Date",
    "חברה",
    "מקור",
    "אומדן לגמר (הוצאות)"/1000 as "אומדן צפי לגמר נוכחי",
    "תקציב הוצאות עדכני"/1000 as "תקציב מעודכן",
    "אומדן קודם (הוצאות)"/1000 as "אומדן צפי לגמר קודם",
    "תקציב הוצאות מקורי"/1000 as "דוח אפס"
from expense_agg

union all

// ==========================
// הכנסות
// ==========================

select
    "פרויקט_ID",
    "Date",
    "חברה",
    'הכנסות' as "מקור",
    "אומדן לגמר (הכנסות)"/1000 as "אומדן צפי לגמר נוכחי",
    "תקציב הכנסות עדכני"/1000 as "תקציב מעודכן",
    "אומדן קודם (הכנסות)"/1000 as "אומדן צפי לגמר קודם",
    "תקציב הכנסות מקורי"/1000 as "דוח אפס"
from revenue_agg
),

gross_profit_agg as (
    select
        "פרויקט_ID",
        "Date",
        "חברה",
        'רווח גולמי' as "מקור",
        sum(case when "מקור" = 'הכנסות' then "אומדן צפי לגמר נוכחי"
                 when "מקור" in ('ישירות', 'כלליות', 'בצ"מ', 'תיקוני בדק ואחריות')
                    then -"אומדן צפי לגמר נוכחי" else 0 end) as "אומדן צפי לגמר נוכחי",

        sum(case when "מקור" = 'הכנסות' then "תקציב מעודכן"
                 when "מקור" in ('ישירות', 'כלליות', 'בצ"מ', 'תיקוני בדק ואחריות')
                    then -"תקציב מעודכן" else 0 end) as "תקציב מעודכן",

        sum(case when "מקור" = 'הכנסות' then "אומדן צפי לגמר קודם" 
                 when "מקור" in ('ישירות', 'כלליות', 'בצ"מ', 'תיקוני בדק ואחריות')
                    then -"אומדן צפי לגמר קודם" else 0 end) as "אומדן צפי לגמר קודם",

        sum(case when "מקור" = 'הכנסות' then "דוח אפס" 
                 when "מקור" in ('ישירות', 'כלליות', 'בצ"מ', 'תיקוני בדק ואחריות')
                    then -"דוח אפס" else 0 end) as "דוח אפס"
from final_table_temp
    group by
        "פרויקט_ID",
        "Date",
        "חברה"
)

select * from gross_profit_agg