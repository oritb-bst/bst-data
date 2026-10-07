-- פיתוח ספציפי להתייקרויות וקיזוזים לפרויקטים
-- K שער העיר ירושלים + גב ים העברית
-- PR25000012 - דצמבר 2025
-- PR25000009 - דצמבר 2025 + פברואר 2026
-- לוקחים מטבלת תנאים מיוחדים במקום מהאומדנים

with control_periods as ( --רשימת תקופות בקרה ייחודית לכל פרויקט
    select distinct
        DOC       as PROJECT_ID,
        DOCNO     as PROJECT_NAME,
        CONDATE   as BUD_CONTROL_DATE,
        SOURCE_DB
    from {{ ref('BUD_FORECAST_R_J') }}
),

control_periods_with_prev as ( --מוצאים את תקופת הבקרה הקודמת בפועל
    select *,
           lag(BUD_CONTROL_DATE) over (partition by PROJECT_ID, SOURCE_DB order by BUD_CONTROL_DATE) as PREV_BUD_CONTROL_DATE
    from control_periods
),

special_conditions as ( --תנאים מיוחדים
    select *
    from {{ ref('PROJ_BUD_FORECAST_COND_STG') }}
),

revenue_forecast as ( --אומדן לגמר הכנסות
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
        try_to_number(regexp_substr(trim(SUBCHAPTERNAME), '^[0-9]+')) as SUBCHAPTER_NUM --חילוץ מספר תת הפרק כדי לזהות 991 / 993
    from {{ ref('BUD_FORECAST_R_J') }}
),

forecast_base as (
    select
        r.*,
        cp.PREV_BUD_CONTROL_DATE,
        -- תנאים מיוחדים של התקופה הנוכחית
        sc_current.CUSTOMER_CUMULATIVE_INCREASE,
        sc_current.CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE,
        sc_current.CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED,
        sc_current.CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE,
        sc_current.CUSTOMER_MANUAL_DEDUCTION_FUTURE,
        -- תנאים מיוחדים של תקופת הבקרה הקודמת
        sc_prev.CUSTOMER_CUMULATIVE_INCREASE              as PREV_CUSTOMER_CUMULATIVE_INCREASE,
        sc_prev.CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE   as PREV_CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE,
        sc_prev.CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED as PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED,
        sc_prev.CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE     as PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE,
        sc_prev.CUSTOMER_MANUAL_DEDUCTION_FUTURE          as PREV_CUSTOMER_MANUAL_DEDUCTION_FUTURE
    from revenue_forecast r

    left join control_periods_with_prev cp
        on  r.PROJECT_ID = cp.PROJECT_ID
        and r.BUD_CONTROL_DATE = cp.BUD_CONTROL_DATE
        and r.SOURCE_DB = cp.SOURCE_DB

    left join special_conditions sc_current
        on  r.PROJECT_ID = sc_current.PROJECT_ID
        and r.BUD_CONTROL_DATE = sc_current.BUD_CONTROL_DATE
        and r.SOURCE_DB = sc_current.SOURCE_DB

    left join special_conditions sc_prev
        on  r.PROJECT_ID = sc_prev.PROJECT_ID
        and cp.PREV_BUD_CONTROL_DATE = sc_prev.BUD_CONTROL_DATE
        and r.SOURCE_DB = sc_prev.SOURCE_DB
),

forecast_calc as ( -- מחשבים את האומדן הנוכחי והאומדן הקודם לפי הלוגיקה העסקית
    select
        *,
        case
            -- תת פרק 991 - התייקרויות
            -- התייקרות עתידית לקבל + מזמין-התייקרות מצטברת
            when PROJECT_NAME in ('PR25000012', 'PR25000009')
            and BUD_CONTROL_DATE = '2025-12-31' --חודש דצמבר
            --or (PROJECT_NAME = 'PR25000009'
            --and BUD_CONTROL_DATE >= '2025-12-01' and BUD_CONTROL_DATE < '2026-03-01')) --חודש דצמבר+פברואר
            --and BUD_CONTROL_DATE >= '2025-12-01' and BUD_CONTROL_DATE < '2026-01-01'))
            and SUBCHAPTER_NUM = 991
            then coalesce(CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE, 0)
               + coalesce(CUSTOMER_CUMULATIVE_INCREASE, 0)
            -- תת פרק 993 - קיזוזים
            -- קיזוז ידני עתידי מזמין + קיזוז חוזי עתידי מזמין + קיזוז חוזי מחש.מזמין
            -- הערך מוכפל ב-1- כי הקיזוזים צריכים להופיע במינוס
            -- 993 - PR25000012
            when PROJECT_NAME = 'PR25000012' 
            and BUD_CONTROL_DATE = '2025-12-31' --חודש דצמבר
            and SUBCHAPTER_NUM = 993
            then coalesce(-1 * nullif(
                 coalesce(CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED, 0)
               + coalesce(CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE, 0)
               + coalesce(CUSTOMER_MANUAL_DEDUCTION_FUTURE, 0) ,0) ,0)
            - 5982000 --קיזוז שאי אפשר להוסיף בפריוריטי אז באופן ידני

            -- 993 - PR25000009
            when PROJECT_NAME = 'PR25000009'
            and BUD_CONTROL_DATE in ('2025-12-31', '2026-02-28') --חודש דצמבר+פברואר
            and SUBCHAPTER_NUM = 993
            then coalesce(-1 * nullif(
                 coalesce(CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED, 0)
                + coalesce(CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE, 0)
                + coalesce(CUSTOMER_MANUAL_DEDUCTION_FUTURE, 0), 0), 0)
            else REVENUE_FORECAST_TO_COMPLETE_ORIGINAL
        end as REVENUE_FORECAST_TO_COMPLETE, --אומדן נוכחי
        
        case -- כאן התנאי נבדק לפי PREV_BUD_CONTROL_DATE,
            -- אם התקופה הקודמת הייתה בתקופה הבעייתית
            -- ותת הפרק הוא 991,
            -- לוקחים את ערכי התנאים המיוחדים של התקופה הקודמת
            when PROJECT_NAME in ('PR25000012', 'PR25000009')
            and PREV_BUD_CONTROL_DATE = '2025-12-31' --חודש דצמבר
            --or (PROJECT_NAME = 'PR25000009'
            --and PREV_BUD_CONTROL_DATE >= '2025-12-01' and PREV_BUD_CONTROL_DATE < '2026-03-01')) --חודש דצמבר+פברואר
            and SUBCHAPTER_NUM = 991
            then coalesce(PREV_CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE, 0)
               + coalesce(PREV_CUSTOMER_CUMULATIVE_INCREASE, 0)
            -- אם התקופה הקודמת הייתה בתקופה הבעייתית
            -- ותת הפרק הוא 993,
            -- לוקחים את הקיזוזים מהתנאים המיוחדים של התקופה הקודמת
            -- בפרויקט PR25000012 מוסיפים גם קיזוז ידני של 5,982,000
            when PROJECT_NAME = 'PR25000012'
            and PREV_BUD_CONTROL_DATE = '2025-12-31' --חודש דצמבר
            and SUBCHAPTER_NUM = 993
            then coalesce(-1 * nullif(coalesce(PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED, 0)
               + coalesce(PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE, 0)
               + coalesce(PREV_CUSTOMER_MANUAL_DEDUCTION_FUTURE,0), 0) ,0)
               - 5982000 --קיזוז שאי אפשר להוסיף בפריוריטי אז באופן ידני
            -- בפרויקט PR25000009 לוקחים את הקיזוזים מהתנאים המיוחדים
            when PROJECT_NAME = 'PR25000009'
            and BUD_CONTROL_DATE in ('2025-12-31', '2026-02-28') --חודש דצמבר+פברואר
            and SUBCHAPTER_NUM = 993
            then coalesce(-1 * nullif(coalesce(PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED, 0)
               + coalesce(PREV_CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE, 0)
               + coalesce(PREV_CUSTOMER_MANUAL_DEDUCTION_FUTURE,0), 0) ,0)
            else PREVIOUS_REVENUE_FORECAST_ORIGINAL
        end as PREVIOUS_REVENUE_FORECAST
    from forecast_base
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