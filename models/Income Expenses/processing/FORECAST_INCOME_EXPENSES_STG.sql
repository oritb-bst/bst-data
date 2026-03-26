select
    TO_DATE('01/' || FORECAST_INCOME_EXPENSES.FORDATE , 'DD/MM/YY') ::DATE AS forecast_month,
    PROJDOCNO as project_doc_no,
    EARNCAST/1000::decimal(18,2) as forecast_revenue_new,
    TOTEXPENSE/1000::decimal(18,2) as forecast_expense_new,
from {{ source('bronze', 'FORECAST_INCOME_EXPENSES') }}