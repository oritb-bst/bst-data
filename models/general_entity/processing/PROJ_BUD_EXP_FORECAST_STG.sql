with base as (
    -- חילוץ מספר תת הפרק הנומרי ישירות מנתוני ההוצאות
    select
        t.*,
        try_to_number(regexp_substr(trim(SUBCHAPTERNAME),'^[0-9]+')) as SUBCHAPTER_NUM
    from {{ ref('BUD_FORECAST_J') }} t
),

--תיקון לפרויקט גב ים העברית בחודש דצמבר - לקחת קיזוזים מתנאים מיוחדים
--טיפול גם במקרה שמסתכלים בחודש פברואר 26 על אומדן קודם
forecast_calc AS (
    SELECT
        o.*,
        -- תיקון אומדן לגמר בדצמבר 2025
        CASE
            WHEN o.DOCNO = 'PR25000009'
            AND o.CONDATE = DATE '2025-12-31'
            AND o.SUBCHAPTER_NUM = 993
            THEN -1*COALESCE(c.CONTRACTOR_CONTRACTUAL_DEDUCTION_FUTURE, 0)
                +
                 COALESCE(c.CONTRACTOR_CONTRACTUAL_DEDUCTION_ACTUAL, 0)
            ELSE o.EFORECAST
        END AS FORECAST_TO_COMPLETE_CALC,
        -- תיקון אומדן קודם בפברואר 2026
        -- על בסיס התנאים המיוחדים של דצמבר 2025
        CASE WHEN o.DOCNO = 'PR25000009'
             AND o.CONDATE = DATE '2026-02-28'
             AND o.SUBCHAPTER_NUM = 993
             THEN -1*COALESCE(c_prev.CONTRACTOR_CONTRACTUAL_DEDUCTION_FUTURE, 0)
                +
                  COALESCE(c_prev.CONTRACTOR_CONTRACTUAL_DEDUCTION_ACTUAL, 0)
            ELSE o.EPREVFORECAST
        END AS PREVIOUS_FORECAST_CALC
    FROM base o

    -- תנאים מיוחדים של החודש הנוכחי
    LEFT JOIN {{ ref('PROJ_BUD_FORECAST_COND_STG') }} c
        ON o.DOCNO = c.PROJECT_NAME
       AND o.CONDATE = c.BUD_CONTROL_DATE
       AND o.SOURCE_DB = c.SOURCE_DB

    -- תנאים מיוחדים של דצמבר 2025
    LEFT JOIN {{ ref('PROJ_BUD_FORECAST_COND_STG') }} c_prev
        ON o.DOCNO = c_prev.PROJECT_NAME
       AND c_prev.BUD_CONTROL_DATE = DATE '2025-12-31'
       AND o.SOURCE_DB = c_prev.SOURCE_DB
       AND o.DOCNO = 'PR25000009'
       AND o.CONDATE = DATE '2026-02-28'
)


/* 11.10.26 - הורדתי כי מירי אמרה לקחת את השדות המקוריים ללא החישוב
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
*/

--אומדנים - אגף ביצוע חישוב רגיל מתת פרק
--תקציבים - חישוב עם האחוז
select
    BUD_FORECAST        as FORECAST_ID,
    BUD_USER            as USER_ID,
    BUD_PERIOD          as BUD_CONTROL_PERIOD_ID,
    CHAPTERNAME         as CHAPTER_NAME,
    CHAPTERDES          as CHAPTER_DES,
    o.SUBCHAPTERNAME    as SUB_CHAPTER_NAME,
    SUBCHAPTERDES       as SUB_CHAPTER_DES,
    o.SUBTOPICNAME      as SUB_TOPIC_NAME,
    SUBTOPICDES         as SUB_TOPIC_DES,
    ACTBUDGETBAL        as ACTUAL_BUDGET_SPENT,
    ACTBUDGETBAL / 1000 as ACTUAL_BUDGET_SPENT_K,
--    EFORECAST           as FORECAST_TO_COMPLETE,
--    EFORECAST / 1000    as FORECAST_TO_COMPLETE_K,
    FORECAST_TO_COMPLETE_CALC        as FORECAST_TO_COMPLETE,
    FORECAST_TO_COMPLETE_CALC / 1000 as FORECAST_TO_COMPLETE_K,
    -- עבור BST ותת פרק 96 התקציב המעודכן מוחלף בחישוב 1.25%
--    case when o.SOURCE_DB = 'BST' and SUBCHAPTER_NUM = 96 then EXECUTION_OVERHEAD_CURRENT_BUDGET        else EBUDGET        end as CURRENT_BUDGET,
--    case when o.SOURCE_DB = 'BST' and SUBCHAPTER_NUM = 96 then EXECUTION_OVERHEAD_CURRENT_BUDGET / 1000 else EBUDGET / 1000 end as CURRENT_BUDGET_K,
    EBUDGET              as CURRENT_BUDGET,
    EBUDGET / 1000       as CURRENT_BUDGET_K,
    APPROVEDTOPAY        as APPROVED_TO_PAY,
    APPROVEDTOPAY / 1000 as APPROVED_TO_PAY_K,
--    EPREVFORECAST        as PREVIOUS_FORECAST,
--    EPREVFORECAST / 1000 as PREVIOUS_FORECAST_K,
    PREVIOUS_FORECAST_CALC        as PREVIOUS_FORECAST,
    PREVIOUS_FORECAST_CALC / 1000 as PREVIOUS_FORECAST_K,
    -- עבור BST ותת פרק 96 תקציב האפס מוחלף בחישוב 1.25%
--    case when o.SOURCE_DB = 'BST' and SUBCHAPTER_NUM = 96 then EXECUTION_OVERHEAD_ORIGINAL_BUDGET        else ORIGBUDGET        end as ORIGINAL_BUDGET,
--    case when o.SOURCE_DB = 'BST' and SUBCHAPTER_NUM = 96 then EXECUTION_OVERHEAD_ORIGINAL_BUDGET / 1000 else ORIGBUDGET / 1000 end as ORIGINAL_BUDGET_K,
    ORIGBUDGET          as ORIGINAL_BUDGET,
    ORIGBUDGET / 1000   as ORIGINAL_BUDGET_K,
    DOC                 as PROJECT_ID,
    o.CONDATE           as BUD_CONTROL_DATE,
    TOPICNAME           as TOPIC_NAME,
    TOPICDES            as TOPIC_DES,
    o.DOCNO             as PROJECT_NAME,
    coalesce(nullif(trim(t.TEXT), ''), nullif(trim(o.BUD_REMARK), '')) as FREE_COMMENT,
    o.SOURCE_DB
from forecast_calc o

left join {{ ref('BUD_FORECASTTEXT_J') }} t --הוספת טקסט חופשי
    on o.DOCNO = t.DOCNO
   and o.CONDATE = t.CONDATE
   and o.SUBCHAPTERNAME = t.SUBCHAPTERNAME
   and o.SUBTOPICNAME = t.SUBTOPICNAME
   and o.SOURCE_DB = t.SOURCE_DB