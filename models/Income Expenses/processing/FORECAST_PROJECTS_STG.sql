select
    TO_DATE('01/' || FORECAST_PROJECTS.FORDATE , 'DD/MM/YY') ::DATE AS forecast_month,
    PROJDOCNO as project_doc_no,
    PROJDES as project_description,
    OORDNAME as order_name,
    STATDES as status_description,
    (EARNCAST/1000) ::INTEGER AS forecast_revenue,
    (TOTEXPENSE/1000) ::INTEGER AS forecast_expense,
    FOREX as id,
    LOAD_TS
from {{ source('bronze', 'FORECAST_PROJECTS') }}