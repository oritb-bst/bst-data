SELECT
    sub.value:PERIOD::NUMBER(13,0)        AS PERIOD,
    sub.value:SUBCHAPTERNAME::STRING      AS SUBCHAPTERNAME,
    sub.value:SUBCHAPTERDES::STRING       AS SUBCHAPTERDES,
    sub.value:RFORECAST::FLOAT            AS RFORECAST,
    sub.value:CUSTPPC::FLOAT              AS CUSTPPC,
    sub.value:RBUDGET_NEW::FLOAT          AS RBUDGET_NEW,
    sub.value:ORIGRBUDGET::FLOAT          AS ORIGRBUDGET,
    sub.value:RPREVFORECAST::FLOAT        AS RPREVFORECAST,
    SOURCE_DB::STRING                     AS SOURCE_DB,
    sub.value:FORECAST::NUMBER(38,0)      AS FORECAST,
    sub.value:DOC::NUMBER(38,0)           AS DOC

FROM {{ source('json', 'BUD_FORECAST_R_SUBFORM') }},
LATERAL FLATTEN(INPUT => DATA) item,
LATERAL FLATTEN(INPUT => item.value:BUD_FORECAST_R_SUBFORM) sub