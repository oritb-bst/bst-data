SELECT
    item.value:ACCOUNT::number(18,0)      AS ACCOUNT,
    item.value:ACCNAME::string            AS ACCNAME,
    item.value:ACCDES::string             AS ACCDES,
    item.value:ACCTYPENAME::string        AS ACCTYPENAME,
    item.value:BUD_DOCNO::string          AS BUD_DOCNO,
    item.value:BUD_PROJ::number(18,0)     AS BUD_PROJ,
    SOURCE_DB::string                     AS SOURCE_DB

FROM {{ source('json', 'ACCOUNTS') }},
LATERAL FLATTEN(input => DATA) item