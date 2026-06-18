select 
    PROJECT_NAME as "שם פרויקט",
    PROJECT_NUMBER as "מספר פרויקט",
    EXPENSE_DATE  as "Date",
    EXPENSE_AMOUNT as "סכום הוצאות",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('EXPENSES') }} a

{{ join_valid_projects('a.PROJECT_NUMBER') }}
