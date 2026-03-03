select
    FORDATE as forecast_month,
    PROJDOCNO as project_doc_no,
    PROJDES as project_description,
    OORDNAME as order_name,
    STATDES as status_description,
    EARNCAST::decimal(18,2) as forecast_revenue,
    TOTEXPENSE::decimal(18,2) as forecast_expense,
    FOREX as id,
    LOAD_TS
from {{ source('bronze', 'FORECAST_PROJECTS') }}