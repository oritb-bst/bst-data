SELECT
    REGEXP_REPLACE(
        TRIM(
            REPLACE(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(
                        sub.value:BUD_FORECASTTEXT_SUBFORM:TEXT::STRING,
                        '<style[^>]*>.*?</style>','',1,0,'is'),'<[^>]+>',' '),'&nbsp;',' ')),'\\s+',' ') AS TEXT,
    sub.value:SUBCHAPTERNAME::STRING AS SUBCHAPTERNAME,
    sub.value:SUBTOPICNAME::STRING   AS SUBTOPICNAME,
    parent.value:DOCNO::VARCHAR      AS DOCNO,
    parent.value:CONDATE::DATE       AS CONDATE,   
    src.SOURCE_DB::STRING            AS SOURCE_DB

FROM {{ source('json', 'BUD_FORECASTTEXT_SUBFORM') }} src, -- סבא
LATERAL FLATTEN(INPUT => src.DATA) parent,                  -- אבא
LATERAL FLATTEN(INPUT => parent.value:BUD_FORECAST_SUBFORM) sub -- נכד

WHERE NULLIF(TRIM(sub.value:BUD_FORECASTTEXT_SUBFORM:TEXT::STRING),'') IS NOT NULL