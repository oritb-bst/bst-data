select
    TO_DATE('01/' || FORECAST_PROJECTS_J.FORDATE , 'DD/MM/YY') ::DATE AS forecast_month,
    PROJDOCNO as project_doc_no,
    PROJDES as project_description,
    OORDNAME as order_name,
    STATDES as status_description,
    EARNCAST AS forecast_revenue,
    TOTEXPENSE AS forecast_expense,
    FOREX as id,
    TOTPRICE as total_purchase_orders_amount,
    TOTMAN as total_site_management_expenses,
    TOTKAB as total_subcontractor_expenses,
    LOAD_TS,
    SOURCE_DB
from {{ ref('FORECAST_PROJECTS_J') }}