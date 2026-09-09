-- MED_OORDLINKING_J מסך בן של חוזים מזמין - הצמדה לחוזה
select
    PROJECT_NAME          as "מספר פרויקט",
    CURRENCY              as "מטבע",
    ESCALATION_START_DATE as "תאריך תחילת הצמדה",
    BASE_RATE             as "שער בסיס",
    SOURCE_DB             as "חברה"
FROM {{ ref('MAZMIN_CONTRACT_ESCALATION_STG') }}