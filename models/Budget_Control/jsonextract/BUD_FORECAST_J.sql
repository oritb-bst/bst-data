SELECT
    sub.value:BUD_FORECAST::NUMBER(13,0)     AS BUD_FORECAST,
    sub.value:BUD_USER::NUMBER(13,0)         AS BUD_USER,
    sub.value:BUD_PERIOD::NUMBER(13,0)       AS BUD_PERIOD,
    sub.value:CHAPTERNAME::STRING            AS CHAPTERNAME,
    sub.value:CHAPTERDES::STRING             AS CHAPTERDES,
    sub.value:SUBCHAPTERNAME::STRING         AS SUBCHAPTERNAME,
    sub.value:SUBCHAPTERDES::STRING          AS SUBCHAPTERDES,
    sub.value:SUBTOPICNAME::STRING           AS SUBTOPICNAME,
    sub.value:SUBTOPICDES::STRING            AS SUBTOPICDES,
    sub.value:ACTBUDGETBAL::FLOAT            AS ACTBUDGETBAL,
    sub.value:EFORECAST::FLOAT               AS EFORECAST,
    sub.value:EBUDGET::FLOAT                 AS EBUDGET,
    sub.value:APPROVEDTOPAY::FLOAT           AS APPROVEDTOPAY,
    sub.value:EPREVFORECAST::FLOAT           AS EPREVFORECAST,
    sub.value:ORIGBUDGET::FLOAT              AS ORIGBUDGET,
    sub.value:DOC::NUMBER(38,0)              AS DOC,
    SOURCE_DB::STRING                        AS SOURCE_DB

FROM {{ source('json', 'BUD_FORECAST_SUBFORM') }},
LATERAL FLATTEN(input => DATA) item,
LATERAL FLATTEN(input => item.value) sub