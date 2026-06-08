select 
    PROJECT_NAME as "שם פרויקט",
    PROJECT_NUMBER as "מספר פרויקט",
    EXPENSE_DATE  as "Date",
    EXPENSE_AMOUNT as "סכום הוצאות",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('EXPENSES') }} t

{{ join_valid_projects('t.PROJECT_NUMBER') }}
where p.SOURCE_DB = 'BST'