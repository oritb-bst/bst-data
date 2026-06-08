select
    forecast_month as "Date",    
    project_doc_no as "מספר פרויקט",   
    forecast_revenue_new,
    forecast_expense_new,
    t.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('FORECAST_INCOME_EXPENSES') }} t

{{ join_valid_projects('t.project_doc_no') }}
where t.SOURCE_DB = 'BST'
