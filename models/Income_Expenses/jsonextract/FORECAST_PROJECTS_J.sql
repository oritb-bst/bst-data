SELECT
    item.value:FORDATE::string        AS FORDATE,
    item.value:PROJDOCNO::string      AS PROJDOCNO,
    item.value:PROJDES::string        AS PROJDES,
    item.value:OORDNAME::string       AS OORDNAME,
    item.value:STATDES::string        AS STATDES,
    item.value:EARNCAST::string       AS EARNCAST,
    item.value:TOTEXPENSE::string     AS TOTEXPENSE,
    item.value:FOREX::string          AS FOREX,
    item.value:TOTMAN::NUMBER(16,2)   AS TOTMAN,
    item.value:TOTPRICE::NUMBER(16,2) AS TOTPRICE,
    SOURCE_DB::string                 AS SOURCE_DB,
    CURRENT_TIMESTAMP()               AS LOAD_TS

FROM {{ source('json', 'BST_FOREXSUB') }},
LATERAL FLATTEN(input => DATA) item