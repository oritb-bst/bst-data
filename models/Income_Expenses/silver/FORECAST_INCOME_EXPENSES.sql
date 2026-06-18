--טבלה לצורך הרצת אוטומציה
select
    forecast_month as "Date",    
    project_doc_no as "מספר פרויקט",   
    forecast_revenue_new,
    forecast_expense_new,
    a.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('FORECAST_INCOME_EXPENSES_STG') }} a


{{ join_valid_projects('a.project_doc_no', 'a.SOURCE_DB') }}