SELECT
    item.value:PROJDOCNO::number        AS PROJDOCNO,
    item.value:SUPNAME::char            AS SUPNAME,
    item.value:CURDATE::date            AS CURDATE,
    item.value:DISPRICE::string         AS DISPRICE,
    item.value:STATDES::string          AS STATDES,
    SOURCE_DB::string                   AS SOURCE_DB

FROM {{ source('json', 'DOCUMENTS_P') }},
LATERAL FLATTEN(input => DATA) item