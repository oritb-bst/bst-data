SELECT
    item.value:PROJDOCNO::string    AS PROJDOCNO,
    item.value:SUPNAME::string      AS SUPNAME,
    item.value:CURDATE::date        AS CURDATE,
    item.value:DISPRICE::float      AS DISPRICE,
    item.value:STATDES::string      AS STATDES,
    item.value:ORDNAME::string      AS ORDNAME,
    item.value:TYPECODE::string      AS TYPECODE,
    item.value:TYPEDES::string      AS TYPEDES,
    SOURCE_DB::string               AS SOURCE_DB 
FROM {{ source('json', 'PORDERS') }},
LATERAL FLATTEN(input => DATA) item