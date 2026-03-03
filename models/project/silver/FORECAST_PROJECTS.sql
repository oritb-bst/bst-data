select
    forecast_month as "חודש ביצוע",    
    project_doc_no as "מספר פרויקט",   
    project_description as "תאור פרויקט",  
    order_name as "חוזה מזמין",    
    status_description as "סטאטוס תחזית", 
    forecast_revenue as "הכנסות",   
    forecast_expense as "הוצאות",    
    id,   
    LOAD_TS 
from {{ ref('FORECAST_PROJECTS_STG') }}
