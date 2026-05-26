SELECT
    item.value:SUP::number          AS SUP,
    item.value:SUPNAME::string      AS SUPNAME,
    item.value:SUPDES::string       AS SUPDES,
    SOURCE_DB::string              AS SOURCE_DB

FROM {{ source('json', 'SUPPLIERS') }},
LATERAL FLATTEN(input => DATA) item