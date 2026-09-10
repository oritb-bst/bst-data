-- MED_OORDLINKING_J מסך בן של חוזים מזמין - הצמדה לחוזה
select
    PROJECT_NAME          as "מספר פרויקט",
    CURRENCY              as "מטבע",
    ESCALATION_START_DATE as "תאריך תחילת הצמדה",
    BASE_RATE             as "שער בסיס",
    c."תיאור מטבע"       as "סוג הצמדה", --הבאת תיאור ההצמדה מטבלת מטבעות
    e.SOURCE_DB           as "חברה"
FROM {{ ref('MAZMIN_CONTRACT_ESCALATION_STG') }} e

left join {{ ref('DIM_CURRENCIES_V_Budget_Control') }} c
    on e.CURRENCY = c."מטבע"
   and e.SOURCE_DB = c."חברה"