select
    forecast_month,    
    project_doc_no,   
    forecast_revenue_new,
    forecast_expense_new,
    SOURCE_DB
from {{ ref('FORECAST_INCOME_EXPENSES_STG') }}
