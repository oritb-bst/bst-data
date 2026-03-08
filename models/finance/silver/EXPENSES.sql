select 
    PROJECT_NAME as "שם פרויקט",
    PROJECT_NUMBER as "מספר פרויקט",
    EXPENSE_DATE as "חודש שנה הוצאות",
    EXPENSE_AMOUNT as "סכום הוצאות",
from {{ ref('EXPENSES_STG') }}