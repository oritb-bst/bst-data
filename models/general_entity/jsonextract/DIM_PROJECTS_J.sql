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
    item.value:BSA_APARTSUM::number     AS BSA_APARTSUM,
    item.value:BUD_STARTORDERDATE::date AS BUD_STARTORDERDATE, --תאריך צו תחילת עבודה
    item.value:BUD_ASTARTDATE::date     AS BUD_ASTARTDATE, --תאריך התחלה בפועל
    item.value:BUD_CONTDURATION::number AS BUD_CONTDURATION, --משך בחודשים חוזי
    item.value:BUD_CONTENDDATE::date    AS BUD_CONTENDDATE, --תאריך סיום ביצוע חוזי
    item.value:BSA_DATE::date           AS BSA_DATE, --שלד
    item.value:BSA_DATE1::date          AS BSA_DATE1, --סיום ומסירה

FROM {{ source('json', 'DIM_PROJECTS') }},
LATERAL FLATTEN(input => DATA) item