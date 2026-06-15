select
    forecast_month,    
    project_doc_no,   
    project_description,  
    order_name,    
    status_description, 
    forecast_revenue,   
    forecast_expense,    
    total_purchase_orders_amount,
    total_site_management_expenses,
    id,   
    LOAD_TS,
    SOURCE_DB
from {{ ref('FORECAST_PROJECTS_STG') }}
