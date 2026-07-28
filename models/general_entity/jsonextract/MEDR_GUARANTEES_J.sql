SELECT
    item.value:PROJNO::varchar        AS PROJNO,
    item.value:PROJDES::varchar       AS PROJDES,
    item.value:BANKNAME::varchar      AS BANKNAME,
    item.value:GUARANTYPEDES::varchar AS GUARANTYPEDES,
    item.value:BANKREF::varchar       AS BANKREF,
    item.value:ACCDES::varchar        AS ACCDES,
    item.value:GSUM::float            AS GSUM,
    item.value:EXCHSUM::float         AS EXCHSUM,
    item.value:SDATE::date            AS SDATE,
    item.value:EXPDATE::date          AS EXPDATE,
    SOURCE_DB::string                 AS SOURCE_DB

FROM {{ source('json', 'MEDR_GUARANTEES') }},
LATERAL FLATTEN(input => DATA) item