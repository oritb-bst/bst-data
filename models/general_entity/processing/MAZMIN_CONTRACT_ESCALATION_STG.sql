-- MED_OORDLINKING_J מסך בן של חוזים מזמין - הצמדה לחוזה
select
    DOCNO as PROJECT_NAME,
    CODE  as CURRENCY,
    STARTDATE as ESCALATION_START_DATE,
    BASEVALUE as BASE_RATE,
    SOURCE_DB
FROM {{ ref('MED_OORDLINKING_J') }}
