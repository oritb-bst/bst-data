SELECT
    item.value:DOCNO::STRING          AS DOCNO,
    item.value:DOC::STRING            AS DOC,
    sub.value:POSITIONCODE::STRING    AS POSITIONCODE,
    sub.value:POSITIONDES::STRING     AS POSITIONDES,
    sub.value:USERNAME::STRING        AS USERNAME,
    SOURCE_DB::STRING                 AS SOURCE_DB

FROM {{ source('json', 'ZCBS_PROJPOSITIONS_SUBFORM') }},
LATERAL FLATTEN(INPUT => DATA) item,
LATERAL FLATTEN(INPUT => item.value:ZCBS_PROJPOSITIONS_SUBFORM) sub

