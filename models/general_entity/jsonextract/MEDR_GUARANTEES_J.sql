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
    item.value:CDES::string           AS CDES,
    item.value:GUARANTYPENAME::varchar AS GUARANTYPENAME,
    item.value:STATDES::string         AS STATDES,
    SOURCE_DB::string                  AS SOURCE_DB

FROM {{ source('json', 'MEDR_GUARANTEES') }},
LATERAL FLATTEN(input => DATA) item