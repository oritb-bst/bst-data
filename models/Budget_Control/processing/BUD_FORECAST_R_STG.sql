WITH raw_data AS (
    SELECT
        subform.value:"PERIOD"::string AS subform_PERIOD,
        subform.value:SUBCHAPTERNAME::string AS subform_SUBCHAPTERNAME,
        subform.value:SUBCHAPTERDES::string AS subform_SUBCHAPTERDES,
        subform.value:RFORECAST::number AS subform_RFORECAST,
        subform.value:CUSTPPC::number AS subform_CUSTPPC,
        subform.value:RBUDGET_NEW::number AS subform_RBUDGET_NEW,
        subform.value:ORIGRBUDGET::number AS subform_ORIGRBUDGET,
        subform.value:RPREVFORECAST::number AS subform_RPREVFORECAST
    FROM {{ source('json', 'BUD_FORECAST_R') }},
    LATERAL FLATTEN(input => DATA:BUD_FORECAST_R_SUBFORM) AS subform
)

--SELECT * FROM raw_data;