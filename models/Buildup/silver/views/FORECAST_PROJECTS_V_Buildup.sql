select
    t.id as "תחזית הוצאות ID",  
    t.forecast_month as "חודש ביצוע",    
    t.project_doc_no as "מספר פרויקט",   
    t.project_description as "תאור פרויקט",  
    t.order_name as "חוזה מזמין",    
    t.status_description as "סטאטוס תחזית", 
    t.forecast_revenue as "הערכת הכנסות",   
    t.forecast_expense as "הערכת הוצאות",    
    t.total_purchase_orders_amount as "סך הזמנות רכש",
    t.total_site_management_expenses as "סהכ הוצ ניהול אתר",
    t.SOURCE_DB  as "חברה"
from {{ ref('FORECAST_PROJECTS_STG') }} t

{{ join_valid_projects_buildup('t.project_doc_no', 't.SOURCE_DB') }}