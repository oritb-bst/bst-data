SELECT
    sub.value:PROJACT::NUMBER(13,0)             AS PROJACT,
    sub.value:DOC::NUMBER(13,0)                 AS DOC,
    sub.value:VERSION::NUMBER(3,0)              AS VERSION,
    sub.value:PROJACTUID::NUMBER(38,0)           AS PROJACTUID,
    sub.value:WBS::STRING                       AS WBS,
    sub.value:ACTDES::STRING                    AS ACTDES,
    sub.value:QPRICE::FLOAT                     AS QPRICE,
    sub.value:MATERIALCOST::FLOAT               AS MATERIALCOST,
    SOURCE_DB::STRING                           AS SOURCE_DB,
    sub.value:BUD_SUBCHAPTERDES::STRING         AS BUD_SUBCHAPTERDES,
    sub.value:BUD_SUBCHAPTERNAME::STRING        AS BUD_SUBCHAPTERNAME

FROM {{ source('json', 'PROJACTS_SUBFORM') }},
LATERAL FLATTEN(INPUT => DATA) item,
LATERAL FLATTEN(INPUT => item.value:PROJACTS_SUBFORM) sub