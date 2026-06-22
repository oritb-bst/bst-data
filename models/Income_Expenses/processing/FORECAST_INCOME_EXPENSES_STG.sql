select
     TO_DATE(
        '01/' || FORDATE,
        'DD/MM/YY'
    ) AS forecast_month,
    PROJDOCNO as project_doc_no,
    forecast_revenue_new,
    forecast_expense_new,
    a.SOURCE_DB
from {{ source('bronze', 'FORECAST_INCOME_EXPENSES') }} a

{{ join_valid_projects('a.PROJDOCNO', 'a.SOURCE_DB') }}
