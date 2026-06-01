SELECT
    item.value:COSTCNAME::char     AS COSTCNAME,
    item.value:COSTCDES::varchar   AS COSTCDES,
    SOURCE_DB::string              AS SOURCE_DB

FROM {{ source('json', 'COSTCENTERS3Q') }},
LATERAL FLATTEN(input => DATA) item