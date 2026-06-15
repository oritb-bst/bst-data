select    
    id                            as "תחזית פרויקט ID",
    project_doc_no                as "מספר פרויקט",  
    concrete_material_expense     as "הוצאות חומרים בטון",
    steel_material_expense        as "הוצאות חומרים ברזל",
    security_management_expense   as "הוצאות ניהול שמירה",
    total_goods_receipt           as "סה""כ קבלות סחורה",
    payroll_management_expense    as "הוצאות ניהול שכר",
    execution_department_expense  as "הוצאות ניהול אגף ביצוע",
    generators_management_expense as "הוצאות ניהול גנרטורים",
    cranes_management_expense     as "הוצאות ניהול מנופים",
    t.SOURCE_DB                   as "חברה",
    p.projtypedes                 as "סוג פרויקט אחרי סינון"
    
from {{ ref('FORECAST_ADDITIONAL_EXPENSES_STG') }} t

{{ join_valid_projects('t.project_doc_no') }}
where t.SOURCE_DB = 'BST'


