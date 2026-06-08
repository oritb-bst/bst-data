select
    forecast_month as "Date",    
    project_doc_no as "מספר פרויקט",   
    project_description as "תאור פרויקט",  
    order_name as "חוזה מזמין",    
    status_description as "סטאטוס תחזית", 
    forecast_revenue as "הכנסות",   
    forecast_expense as "הוצאות",    
    id as "תחזית הוצאות ID",   
    LOAD_TS,
    t.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('FORECAST_PROJECTS') }} t

{{ join_valid_projects('t.project_doc_no') }}
where t.SOURCE_DB = 'BST'

