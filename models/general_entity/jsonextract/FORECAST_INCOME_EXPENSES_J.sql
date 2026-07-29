SELECT
    item.value:FORDATE::string          AS FORDATE,
    item.value:PROJDOCNO::string        AS PROJDOCNO,
    SOURCE_DB::string                   AS SOURCE_DB,
    NULL::FLOAT                         AS forecast_revenue_new,
    NULL::FLOAT                         AS forecast_expense_new

FROM {{ source('json', 'BST_FOREXSUB') }},
LATERAL FLATTEN(input => DATA) item

