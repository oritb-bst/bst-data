SELECT
    item.value:IVNUM::string            AS IVNUM,
    item.value:PROJDOCNO::string        AS DOC_PROJECT,
    item.value:IVDATE::date             AS IVDATE,
    item.value:TOTPRICE::number(18,2)   AS TOTPRICE,
    item.value:IV::number(18,0)         AS IV,
    SOURCE_DB::string                   AS SOURCE_DB

FROM {{ source('json', 'CINVOICES') }},
LATERAL FLATTEN(input => DATA) item