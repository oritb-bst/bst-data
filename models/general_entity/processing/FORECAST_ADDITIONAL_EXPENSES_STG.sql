select  
    FOREX     as id,
    PROJDOCNO as project_doc_no,
    MATERIAL1 as concrete_material_expense,
    MATERIAL2 as steel_material_expense,
    MANAGE6   as security_management_expense,
    MATERIAL4 as total_goods_receipt,
    MANAGE1   as payroll_management_expense,
    MANAGE3   as execution_department_expense,
    MANAGE7   as generators_management_expense,
    MANAGE8   as cranes_management_expense,
    SOURCE_DB
from {{ ref('BST_FOREXSUBA_J') }}

