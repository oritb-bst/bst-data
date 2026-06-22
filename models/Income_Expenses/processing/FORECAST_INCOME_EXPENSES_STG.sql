select
     TO_DATE(
        '01/' || FORDATE,
        'DD/MM/YY'
    ) AS forecast_month,
    PROJDOCNO as project_doc_no,
    forecast_revenue_new,
    forecast_expense_new,
    a.SOURCE_DB
from {{ ref('FORECAST_INCOME_EXPENSES_J') }} a

{{ join_valid_projects('a.PROJDOCNO', 'a.SOURCE_DB') }}
