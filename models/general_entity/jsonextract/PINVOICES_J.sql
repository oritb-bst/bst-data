--חשבוניות ספק מרכזות
SELECT
    item.value:IVNUM::string         AS IVNUM,
    item.value:PROJDOCNO::string     AS PROJDOCNO,
    item.value:IVDATE::date          AS IVDATE,
    item.value:QPRICE::float         AS QPRICE,
    item.value:DISPRICE::float       AS DISPRICE,
    item.value:TOTPRICE::float       AS TOTPRICE,
    item.value:STORNOFLAG::string    AS STORNOFLAG,
    item.value:SUPNAME::string       AS SUPNAME,
    item.value:FINAL::string         AS FINAL,
    item.value:STATDES::string       AS STATDES,
    item.value:ORDNAME::string       AS ORDNAME,
    SOURCE_DB::string                AS SOURCE_DB

FROM {{ source('json', 'PINVOICES') }},
LATERAL FLATTEN(input => DATA) item