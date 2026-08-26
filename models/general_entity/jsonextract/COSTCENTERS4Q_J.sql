--משאבים
SELECT
    item.value:COSTCNAME::string   AS COSTCNAME,
    item.value:COSTCDES::string    AS COSTCDES,
    SOURCE_DB::string              AS SOURCE_DB

FROM {{ source('json', 'COSTCENTERS4Q') }},
LATERAL FLATTEN(input => DATA) item