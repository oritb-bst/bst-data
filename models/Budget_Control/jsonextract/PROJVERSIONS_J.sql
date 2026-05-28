SELECT
    sub.value:CURDATE::DATE         AS CURDATE,
    sub.value:VERSION::NUMBER(38,0) AS VERSION,
    sub.value:TEXT::STRING          AS TEXT,
    sub.value:BUD_ZERO::STRING      AS BUD_ZERO,
    sub.value:BUD_EXECUTE::STRING   AS BUD_EXECUTE,
    SOURCE_DB::STRING               AS SOURCE_DB,
    sub.value:DOC::NUMBER(38,0)     AS DOC

FROM {{ source('json', 'PROJVERSIONS_SUBFORM') }},
LATERAL FLATTEN(INPUT => DATA) item,
LATERAL FLATTEN(INPUT => item.value) sub