with base as (
    -- חילוץ מספר תת הפרק הנומרי ישירות מנתוני ההוצאות
    select
        t.*,
        try_to_number(regexp_substr(trim(SUBCHAPTERNAME),'^[0-9]+')) as SUBCHAPTER_NUM
    from {{ ref('BUD_FORECAST_J') }} t
),

overhead_calc as (
    -- חישוב תקציבי אגף ביצוע כ-1.25% מהוצאות ישירות, כלליות ובדק ואחריות עבור BST
    select
        *,
        -- תקציב מעודכן אגף ביצוע 
        sum(case when SOURCE_DB = 'BST' and (SUBCHAPTER_NUM between 1 and 80
                     or SUBCHAPTER_NUM = 81
                     or SUBCHAPTER_NUM between 83 and 95
                     or SUBCHAPTER_NUM in (99, 991, 992, 993))
                 and SUBCHAPTER_NUM <> 82 and SUBCHAPTER_NUM <> 96 then coalesce(EBUDGET, 0)
                else 0 end) over (partition by DOCNO,DOC,CONDATE,SOURCE_DB) * 0.0125
            as EXECUTION_OVERHEAD_CURRENT_BUDGET,

        -- תקציב מקורי אגף ביצוע 
        sum(case when SOURCE_DB = 'BST' and (SUBCHAPTER_NUM between 1 and 80
                     or SUBCHAPTER_NUM = 81
                     or SUBCHAPTER_NUM between 83 and 95
                     or SUBCHAPTER_NUM in (99, 991, 992, 993))
                 and SUBCHAPTER_NUM <> 82 and SUBCHAPTER_NUM <> 96 then coalesce(ORIGBUDGET, 0)
                else 0 end) over (partition by DOCNO,DOC,CONDATE,SOURCE_DB) * 0.0125
            as EXECUTION_OVERHEAD_ORIGINAL_BUDGET
    from base
)

select
    BUD_FORECAST as FORECAST_ID,
    BUD_USER as USER_ID,
    BUD_PERIOD as BUD_CONTROL_PERIOD_ID,
    CHAPTERNAME as CHAPTER_NAME,
    CHAPTERDES as CHAPTER_DES,
    SUBCHAPTERNAME as SUB_CHAPTER_NAME,
    SUBCHAPTERDES as SUB_CHAPTER_DES,
    SUBTOPICNAME as SUB_TOPIC_NAME,
    SUBTOPICDES as SUB_TOPIC_DES,
    ACTBUDGETBAL as ACTUAL_BUDGET_SPENT,
    ACTBUDGETBAL / 1000 as ACTUAL_BUDGET_SPENT_K,
    EFORECAST as FORECAST_TO_COMPLETE,
    EFORECAST / 1000 as FORECAST_TO_COMPLETE_K,
    -- עבור BST ותת פרק 96 התקציב המעודכן מוחלף בחישוב 1.25%
    case when SOURCE_DB = 'BST' and SUBCHAPTER_NUM = 96 then EXECUTION_OVERHEAD_CURRENT_BUDGET else EBUDGET end as CURRENT_BUDGET,
    case when SOURCE_DB = 'BST' and SUBCHAPTER_NUM = 96 then EXECUTION_OVERHEAD_CURRENT_BUDGET / 1000 else EBUDGET / 1000 end as CURRENT_BUDGET_K,
    APPROVEDTOPAY as APPROVED_TO_PAY,
    APPROVEDTOPAY / 1000 as APPROVED_TO_PAY_K,
    EPREVFORECAST as PREVIOUS_FORECAST,
    EPREVFORECAST / 1000 as PREVIOUS_FORECAST_K,
    -- עבור BST ותת פרק 96 תקציב האפס מוחלף בחישוב 1.25%
    case when SOURCE_DB = 'BST' and SUBCHAPTER_NUM = 96 then EXECUTION_OVERHEAD_ORIGINAL_BUDGET else ORIGBUDGET end as ORIGINAL_BUDGET,
    case when SOURCE_DB = 'BST' and SUBCHAPTER_NUM = 96 then EXECUTION_OVERHEAD_ORIGINAL_BUDGET / 1000 else ORIGBUDGET / 1000 end as ORIGINAL_BUDGET_K,
    DOC as PROJECT_ID,
    CONDATE as BUD_CONTROL_DATE,
    TOPICNAME as TOPIC_NAME,
    TOPICDES as TOPIC_DES,
    DOCNO as PROJECT_NAME,
    SOURCE_DB
from overhead_calc