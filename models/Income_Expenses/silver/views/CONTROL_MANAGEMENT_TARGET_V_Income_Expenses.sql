select 
    PROJECT_NAME as "שם פרויקט",
    POCKET_NUMBER as "מספר פרויקט",
    TARGET_CONTROL_EXPENSES as "יעד בקרה הוצאות",
    TARGET_CONTROL_REVENUES as "יעד בקרה הכנסות",
    TARGET_MANAGEMENT_EXPENSES as "יעד הנהלה הוצאות",
    TARGET_MANAGEMENT_REVENUES as "יעד הנהלה הכנסות",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('CONTROL_MANAGEMENT_TARGET') }} t

{{ join_valid_projects('t.POCKET_NUMBER') }}
where p.SOURCE_DB = 'BST'
