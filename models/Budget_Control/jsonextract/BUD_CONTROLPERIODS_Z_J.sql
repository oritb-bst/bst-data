SELECT
    item.value:PERIOD::number(13,0)     AS PERIOD,
    item.value:DOC::number(13,0)        AS DOC,
    item.value:CONMONTH::string         AS CONMONTH,
    item.value:CONDATE::date            AS CONDATE,
    item.value:CURVERSION::number(3,0)  AS CURVERSION,
    SOURCE_DB::string                   AS SOURCE_DB,
    item.value:DOCNO::string            AS DOCNO

FROM {{ source('json', 'BUD_CONTROLPERIODS_Z') }},
LATERAL FLATTEN(input => DATA) item