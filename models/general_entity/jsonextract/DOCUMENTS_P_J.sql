SELECT
    item.value:PROJDOCNO::string        AS PROJDOCNO,
    item.value:SUPNAME::string            AS SUPNAME,
    item.value:CURDATE::date            AS CURDATE,
    item.value:DISPRICE::float         AS DISPRICE,
    item.value:STATDES::string          AS STATDES,
    SOURCE_DB::string                   AS SOURCE_DB

FROM {{ source('json', 'DOCUMENTS_P') }},
LATERAL FLATTEN(input => DATA) item