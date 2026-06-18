select    
    id,
    concrete_material_expense,
    steel_material_expense,
    security_management_expense,
    total_goods_receipt,
    payroll_management_expense,
    execution_department_expense,
    generators_management_expense,
    cranes_management_expense,
    source_db
    
from {{ ref('FORECAST_ADDITIONAL_EXPENSES_STG') }}
