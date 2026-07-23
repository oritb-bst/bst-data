--קובץ אקסל-יעד הנהלה
select 
    PROJECT_NAME as "שם פרויקט",
    POCKET_NUMBER as "מספר פרויקט",
    TARGET_CONTROL_EXPENSES as "יעד בקרה הוצאות",
    TARGET_CONTROL_REVENUES as "יעד בקרה הכנסות",
    TARGET_MANAGEMENT_EXPENSES as "יעד הנהלה הוצאות באלפי שח",
    TARGET_MANAGEMENT_REVENUES as "יעד הנהלה הכנסות באלפי שח",
    TARGET_MANAGEMENT_EXPENSES*1000 as "יעד הנהלה הוצאות",
    TARGET_MANAGEMENT_REVENUES*1000 as "יעד הנהלה הכנסות"
from {{ ref('CONTROL_MANAGEMENT_TARGET') }} t

{{ join_bst_projects_without_sourceDB_budget_control('t.POCKET_NUMBER') }}