--BUD_PROJSECTCOSTC_SUBFORM נמצא תחת הנכד השני (BUD_FORECASTTEXT_SUBFORM)
SELECT
    cost.value:UNITNAME::VARCHAR        AS UNITNAME,
    cost.value:SONQUANT::FLOAT          AS SONQUANT,
    cost.value:PURCHASEPRICE::FLOAT     AS PURCHASEPRICE,
    cost.value:TOTPURCHASEPRICE::FLOAT  AS TOTPURCHASEPRICE,

    sub.value:SUBCHAPTERNAME::STRING    AS SUBCHAPTERNAME, --מספר תת פרק
    sub.value:SUBTOPICNAME::STRING      AS SUBTOPICNAME, --מספר משאב
    sub.value:TOPICNAME::STRING         AS TOPICNAME, --מספר נושא

    parent.value:DOCNO::VARCHAR         AS DOCNO,
    parent.value:CONDATE::DATE          AS CONDATE,
    src.SOURCE_DB::VARCHAR              AS SOURCE_DB

FROM {{ source('json', 'BUD_FORECASTTEXT_SUBFORM') }} src,
LATERAL FLATTEN(INPUT => src.DATA) parent,
LATERAL FLATTEN(INPUT => parent.value:BUD_FORECAST_SUBFORM) sub,
LATERAL FLATTEN(INPUT => sub.value:BUD_PROJSECTCOSTC_SUBFORM) cost