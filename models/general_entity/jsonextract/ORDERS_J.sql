SELECT
    item.value:ORD::string        AS ORD,
    item.value:CUSTNAME::string   AS CUSTNAME,
    item.value:ORDNAME::string    AS ORDNAME,
    SOURCE_DB::string            AS SOURCE_DB

FROM {{ source('json', 'ORDERS') }},
LATERAL FLATTEN(input => DATA) item