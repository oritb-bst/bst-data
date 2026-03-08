select
      DATE_FROM_PARTS(
        2000 + TO_NUMBER(RIGHT(FORDATE, 2)),  -- שנה: '26' → 2026
        TO_NUMBER(LEFT(FORDATE, 2)),          -- חודש: '01' → 1
        1                                     -- יום ראשון של החודש
    ) AS forecast_month,
    PROJDOCNO as project_doc_no,
    PROJDES as project_description,
    OORDNAME as order_name,
    STATDES as status_description,
    EARNCAST::decimal(18,2) as forecast_revenue,
    TOTEXPENSE::decimal(18,2) as forecast_expense,
    FOREX as id,
    LOAD_TS
from {{ source('bronze', 'FORECAST_PROJECTS') }}