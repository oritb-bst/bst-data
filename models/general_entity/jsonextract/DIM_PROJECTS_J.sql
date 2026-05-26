SELECT
    item.value:DOCNO::string            AS DOCNO,
    item.value:DOC::number              AS DOC,
    item.value:PROJMANG::string         AS PROJMANG,
    item.value:PROJTYPECODE::number     AS PROJTYPECODE,
    item.value:PROJTYPEDES::string      AS PROJTYPEDES,
    item.value:PROJDES::string          AS PROJDES,
    item.value:STATDES::string          AS STATDES,
    SOURCE_DB::string                   AS SOURCE_DB,
    item.value:BSA_SIZESUM::float       AS BSA_SIZESUM,
    item.value:BSA_APARTSUM::number     AS BSA_APARTSUM

FROM {{ source('json', 'DIM_PROJECTS') }},
LATERAL FLATTEN(input => DATA) item