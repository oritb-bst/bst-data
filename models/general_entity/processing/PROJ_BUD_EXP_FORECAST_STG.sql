with base as (
    select
        t.*,
        case
            when cc."מקור" = 'אגף ביצוע' then 'העמסת אגף ביצוע'
            when cc."מקור" = 'תיקוני בדק ואחריות' then 'בדק ואחריות'
            when cc."מקור" = 'כלליות' then 'סך הוצ כלליות'
            when cc."מקור" = 'ישירות' then 'סך הוצ ישירות'
            else cc."מקור"
        end as EXPENSE_SOURCE
    from {{ ref('BUD_FORECAST_J') }} t

    left join {{ ref('DIM_SUBCHAPTERS_V_Budget_Control') }} cc
        on coalesce(t.SUBCHAPTERNAME, 'ללא') = cc."מספר תת פרק"
        and t.SOURCE_DB = cc."חברה"
),


overhead_calc as (
    -- חישוב תקציב אגף ביצוע כ-1.25% מהוצאות ישירות, כלליות ובדק ואחריות
    select
        *,
        sum(case when EXPENSE_SOURCE in (
                    'סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות') then coalesce(EBUDGET, 0) else 0 end) over (partition by
                DOCNO,DOC,CONDATE,SOURCE_DB,BUD_FORECAST,BUD_PERIOD) * 0.0125 as EXECUTION_OVERHEAD_CURRENT_BUDGET,
        sum(case when EXPENSE_SOURCE in ('סך הוצ ישירות','סך הוצ כלליות','בדק ואחריות') then coalesce(ORIGBUDGET, 0) else 0 end) over (partition by
                DOCNO,DOC,CONDATE,SOURCE_DB,BUD_FORECAST,BUD_PERIOD) * 0.0125 as EXECUTION_OVERHEAD_ORIGINAL_BUDGET
from base
)


select
    BUD_FORECAST as FORECAST_ID,
    BUD_USER     as USER_ID,
    BUD_PERIOD   as BUD_CONTROL_PERIOD_ID,
    CHAPTERNAME  as CHAPTER_NAME,
    CHAPTERDES   as CHAPTER_DES,
    SUBCHAPTERNAME as SUB_CHAPTER_NAME,
    SUBCHAPTERDES  as SUB_CHAPTER_DES,
    SUBTOPICNAME   as SUB_TOPIC_NAME,
    SUBTOPICDES    as SUB_TOPIC_DES,
    ACTBUDGETBAL   as ACTUAL_BUDGET_SPENT,
    ACTBUDGETBAL / 1000 as ACTUAL_BUDGET_SPENT_K,
    EFORECAST as FORECAST_TO_COMPLETE, --אומדן לגמר הוצאות (לפי תת פרק 96)
    EFORECAST / 1000 as FORECAST_TO_COMPLETE_K, --אומדן לגמר הוצאות (לפי תת פרק 96)
    case when SUBCHAPTERNAME = '96' then EXECUTION_OVERHEAD_CURRENT_BUDGET else EBUDGET end as CURRENT_BUDGET, --(1.25% תקציב הוצאות עדכני (לפי חישוב
    case when SUBCHAPTERNAME = '96' then EXECUTION_OVERHEAD_CURRENT_BUDGET / 1000 else EBUDGET / 1000 end as CURRENT_BUDGET_K, --(1.25% תקציב הוצאות עדכני (לפי חישוב
    APPROVEDTOPAY as APPROVED_TO_PAY,
    APPROVEDTOPAY / 1000 as APPROVED_TO_PAY_K,
    EPREVFORECAST as PREVIOUS_FORECAST, --אומדן קודם (לפי תת פרק 96)
    EPREVFORECAST / 1000 as PREVIOUS_FORECAST_K, --אומדן קודם (לפי תת פרק 96)
    case when SUBCHAPTERNAME = '96' then EXECUTION_OVERHEAD_ORIGINAL_BUDGET else ORIGBUDGET end as ORIGINAL_BUDGET, --(1.25% תקציב הוצאות מקורי (לפי חישוב
    case when SUBCHAPTERNAME = '96' then EXECUTION_OVERHEAD_ORIGINAL_BUDGET / 1000 else ORIGBUDGET / 1000 end as ORIGINAL_BUDGET_K, --(1.25% תקציב הוצאות מקורי (לפי חישוב
    DOC       as PROJECT_ID,
    CONDATE   as BUD_CONTROL_DATE,
    TOPICNAME as TOPIC_NAME,
    TOPICDES  as TOPIC_DES,
    DOCNO    as PROJECT_NAME,
    SOURCE_DB
from overhead_calc