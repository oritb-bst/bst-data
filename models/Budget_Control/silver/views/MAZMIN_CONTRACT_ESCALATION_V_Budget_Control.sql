-- MED_OORDLINKING_J מסך בן של חוזים מזמין - הצמדה לחוזה
select
    PROJECT_NAME          as "מספר פרויקט",
    ORD_NAME              as "מספר חוזה מזמין",
    CURRENCY_LINKAGE      as "מטבע הצמדה",
    ESCALATION_START_DATE as "תאריך תחילת הצמדה",
    BASE_RATE             as "שער בסיס",
    CURRENCY_LINKAGE_DES  as "תיאור מטבע הצמדה",
    SOURCE_DB             as "חברה"
FROM {{ ref('MAZMIN_CONTRACT_ESCALATION_STG') }}