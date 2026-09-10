-- MED_OORDLINKING_J מסך בן של חוזים מזמין - הצמדה לחוזה
select
    DOCNO   as PROJECT_NAME, --שדה של האבא
    ORDNAME as ORD_NAME, --שדה של האבא
    e.CODE    as CURRENCY,
    STARTDATE as ESCALATION_START_DATE,
    BASEVALUE as BASE_RATE,
    c.CURRENCY_DES, --תיאור מטבע מטבלת מטבעות
    e.SOURCE_DB
FROM {{ ref('MED_OORDLINKING_J') }} e

left join {{ ref('DIM_CURRENCIES_STG') }} c
    on e.CODE = c.CURRENCY
   and e.SOURCE_DB = c.SOURCE_DB
