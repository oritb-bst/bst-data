SELECT
    item.value:PROJDOCNO::string        AS DOC_PROJECT,
    item.value:IVDATE::date             AS IVDATE,
    SOURCE_DB::string                   AS SOURCE_DB,
    NULL::FLOAT                         AS INVOICES_ACTUALLY_NEW,
    NULL::FLOAT                         AS INVOICES_ACTUALLY_EXPENSE_NEW

FROM {{ source('json', 'INVOICES_ACTUALLY') }},
LATERAL FLATTEN(input => DATA) item