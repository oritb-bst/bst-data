select 
    PROJECT_NAME,
    PROJECT_NUMBER,
    EXPENSE_DATE,
    EXPENSE_AMOUNT,
from {{ ref('EXPENSES_STG') }}