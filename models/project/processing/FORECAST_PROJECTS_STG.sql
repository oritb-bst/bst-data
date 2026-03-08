select
 TO_CHAR(
        DATE_FROM_PARTS(
            2000 + TO_NUMBER(RIGHT(FORECAST_PROJECTS.FORDATE,2)),  -- שנה
            TO_NUMBER(LEFT(FORECAST_PROJECTS.FORDATE,2)),          -- חודש
            1                                                      -- יום
        ),
        'DD/MM/YYYY'
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