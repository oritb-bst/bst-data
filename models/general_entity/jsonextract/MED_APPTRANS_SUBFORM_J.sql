SELECT
    sub.value:SECTION::STRING     AS SECTION,
    sub.value:SECDES::STRING      AS SECDES,
    sub.value:QPRICE_TO::FLOAT    AS QPRICE_TO,
    sub.value:QPRICE_TO_BD::FLOAT AS QPRICE_TO_BD,
    src.SOURCE_DB::STRING         AS SOURCE_DB,
    -- נתונים מהמסמך הראשי / הסבא
    parent.value:DOC::NUMBER(13,0)    AS DOC,
    parent.value:PROJDOCNO::VARCHAR   AS PROJDOCNO,
    parent.value:MED_EXEMONTH::STRING AS MED_EXEMONTH,

FROM {{ source('json', 'MED_APPTRANS_SUBFORM') }} src,
LATERAL FLATTEN(INPUT => src.DATA) parent,
LATERAL FLATTEN(INPUT => parent.value:MED_DOCAPPSUMS_SUBFORM:MED_APPTRANS_SUBFORM) sub