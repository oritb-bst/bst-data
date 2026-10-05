--פיתוח ספציפי להתייקרויות וקיזוזים לפרויקטים K
--K שער העיר ירושלים + גב ים העברית
--בחודשים 11/25-02/26
--לוקחים מטבלת תנאים מיוחדים במקום מהאומדנים

with special_conditions as (
    -- מוסיפים לכל שדה גם את הערך שלו מתקופת הבקרה הקודמת
    select
        *,
        lag(CUSTOMER_CUMULATIVE_INCREASE) over (partition by PROJECT_ID, SOURCE_DB order by BUD_CONTROL_DATE)              as PREV_CUSTOMER_CUMULATIVE_INCREASE,
        lag(CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE) over (partition by PROJECT_ID, SOURCE_DB order by BUD_CONTROL_DATE)   as PREV_CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE,
        lag(CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED) over (partition by PROJECT_ID, SOURCE_DB order by BUD_CONTROL_DATE) as PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED,
        lag(CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE) over (partition by PROJECT_ID, SOURCE_DB order by BUD_CONTROL_DATE)     as PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE,
        lag(CUSTOMER_MANUAL_DEDUCTION_FUTURE) over (partition by PROJECT_ID, SOURCE_DB order by BUD_CONTROL_DATE)          as PREV_CUSTOMER_MANUAL_DEDUCTION_FUTURE
    from {{ ref('PROJ_BUD_FORECAST_COND_STG') }}
),

revenue_forecast as (
    -- מביאים את כל השדות עם השמות הסופיים של ה-DWH
    select
        FORECAST               as FORECAST_ID,
        "PERIOD"               as BUD_CONTROL_PERIOD_ID,
        SUBCHAPTERNAME         as SUB_CHAPTER_NAME,
        SUBCHAPTERDES          as SUB_CHAPTER_DES,
        RFORECAST              as REVENUE_FORECAST_TO_COMPLETE_ORIGINAL,
        CUSTPPC                as CUSTOMER_ACCOUNT,
        RBUDGET_NEW            as CURRENT_REVENUE_BUDGET,
        ORIGRBUDGET            as ORIGINAL_REVENUE_BUDGET,
        RPREVFORECAST          as PREVIOUS_REVENUE_FORECAST_ORIGINAL,
        DOC                    as PROJECT_ID,
        CONDATE                as BUD_CONTROL_DATE,
        DOCNO                  as PROJECT_NAME,
        BUD_REMARK             as FREE_COMMENT,
        SOURCE_DB,
        -- חילוץ מספר תת הפרק כדי לזהות 991 / 993
        try_to_number(
            regexp_substr(trim(SUBCHAPTERNAME), '^[0-9]+')
        ) as SUBCHAPTER_NUM
    from {{ ref('BUD_FORECAST_R_J') }}
),

forecast_calc as (
    -- חישוב האומדן הנוכחי והקודם לפי הלוגיקה המיוחדת
    select
        r.*,
        case
            when r.PROJECT_NAME in ('PR25000009', 'PR25000012')
             and r.BUD_CONTROL_DATE >= '2025-11-01'
             and r.BUD_CONTROL_DATE <  '2026-03-01'
             and r.SUBCHAPTER_NUM = 991
            then coalesce(sc.CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE, 0)
               + coalesce(sc.CUSTOMER_CUMULATIVE_INCREASE, 0)

            when r.PROJECT_NAME in ('PR25000009', 'PR25000012')
             and r.BUD_CONTROL_DATE >= '2025-11-01'
             and r.BUD_CONTROL_DATE <  '2026-03-01'
             and r.SUBCHAPTER_NUM = 993
            then -1 * (coalesce(sc.CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED, 0)
               + coalesce(sc.CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE, 0)
               + coalesce(sc.CUSTOMER_MANUAL_DEDUCTION_FUTURE, 0))
            else r.REVENUE_FORECAST_TO_COMPLETE_ORIGINAL end as REVENUE_FORECAST_TO_COMPLETE, --אומדן נוכחי

        case
            when r.PROJECT_NAME in ('PR25000009', 'PR25000012')
             and r.BUD_CONTROL_DATE >= '2025-11-01'
             and r.BUD_CONTROL_DATE <  '2026-03-01'
             and r.SUBCHAPTER_NUM = 991
            then coalesce(sc.PREV_CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE, 0)
               + coalesce(sc.PREV_CUSTOMER_CUMULATIVE_INCREASE, 0)

            when r.PROJECT_NAME in ('PR25000009', 'PR25000012')
             and r.BUD_CONTROL_DATE >= '2025-11-01'
             and r.BUD_CONTROL_DATE <  '2026-03-01'
             and r.SUBCHAPTER_NUM = 993
            then -1 * (coalesce(sc.PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED, 0)
               + coalesce(sc.PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE, 0)
               + coalesce(sc.PREV_CUSTOMER_MANUAL_DEDUCTION_FUTURE, 0))
            else r.PREVIOUS_REVENUE_FORECAST_ORIGINAL end as PREVIOUS_REVENUE_FORECAST --אומדן קודם
    from revenue_forecast r

    left join special_conditions sc
        on  r.PROJECT_ID = sc.PROJECT_ID
        and r.BUD_CONTROL_DATE = sc.BUD_CONTROL_DATE
        and r.SOURCE_DB = sc.SOURCE_DB
)

select
    FORECAST_ID,
    BUD_CONTROL_PERIOD_ID,
    SUB_CHAPTER_NAME,
    SUB_CHAPTER_DES,
    REVENUE_FORECAST_TO_COMPLETE,
    REVENUE_FORECAST_TO_COMPLETE / 1000 as REVENUE_FORECAST_TO_COMPLETE_K,
    CUSTOMER_ACCOUNT,
    CUSTOMER_ACCOUNT / 1000 as CUSTOMER_ACCOUNT_K,
    CURRENT_REVENUE_BUDGET,
    CURRENT_REVENUE_BUDGET / 1000 as CURRENT_REVENUE_BUDGET_K,
    ORIGINAL_REVENUE_BUDGET,
    ORIGINAL_REVENUE_BUDGET / 1000 as ORIGINAL_REVENUE_BUDGET_K,
    PREVIOUS_REVENUE_FORECAST,
    PREVIOUS_REVENUE_FORECAST / 1000 as PREVIOUS_REVENUE_FORECAST_K,
    PROJECT_ID,
    BUD_CONTROL_DATE,
    PROJECT_NAME,
    FREE_COMMENT,
    SOURCE_DB
from forecast_calc