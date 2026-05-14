select
    forecast_month as "Date",    
    project_doc_no as "מספר פרויקט",   
    forecast_revenue_new,
    forecast_expense_new,
    SOURCE_DB  as "חברה"
from {{ ref('FORECAST_INCOME_EXPENSES') }}
