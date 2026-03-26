select
    forecast_month as "Date",    
    project_doc_no as "מספר פרויקט",   
    forecast_revenue_new,
    forecast_expense_new,    
from {{ ref('FORECAST_INCOME_EXPENSES_STG') }}
