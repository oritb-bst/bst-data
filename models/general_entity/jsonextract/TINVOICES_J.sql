{{ config(enabled=false) }}

SELECT
    item.value:IVNUM::string            AS IVNUM,
    item.value:PROJDOCNO::string        AS PROJDOCNO,
    item.value:IVDATE::date             AS IVDATE,
    item.value:TOTPRICE::number(18,2)   AS TOTPRICE,
    item.value:DISPRICE::number(18,2)   AS DISPRICE,
    item.value:STATDES::string          AS STATDES,
    item.value:DETAILS::string          AS DETAILS,
    item.value:STORNOFLAG::string       AS STORNOFLAG,
    item.value:FINAL::string            AS FINAL,
    item.value:ACCNAME::string          AS ACCNAME,
    SOURCE_DB::string                   AS SOURCE_DB

FROM {{ source('json', 'TINVOICES') }},
LATERAL FLATTEN(input => DATA) item