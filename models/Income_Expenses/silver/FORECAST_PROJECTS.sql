select
    forecast_month,    
    project_doc_no,   
    project_description,  
    order_name,    
    status_description, 
    forecast_revenue,   
    forecast_expense,    
    id,   
    LOAD_TS,
    SOURCE_DB
from {{ ref('FORECAST_PROJECTS_STG') }}
