--מסך חשבון חלקי קבלן >> פרטי עכבונות/קיזוזים 
SELECT
    sub.value:BUD_SUBTOPICNAME::STRING AS BUD_SUBTOPICNAME,
    sub.value:RETDES::STRING           AS RETDES,
    sub.value:QPRICE_TO::FLOAT         AS QPRICE_TO,
    item.value:CURDATE::DATE           AS CURDATE, --שדה של האבא
    item.value:PROJDOCNO::VARCHAR      AS PROJDOCNO, --שדה של האבא
    item.value:DOCNO::VARCHAR          AS DOCNO, --שדה של האבא
    SOURCE_DB::string                  AS SOURCE_DB

FROM {{ source('json', 'MED_DOCRETENTION_SUBFORM') }},
LATERAL FLATTEN(INPUT => DATA) item,
LATERAL FLATTEN(INPUT => item.value:MED_DOCRETENTION_SUBFORM) sub