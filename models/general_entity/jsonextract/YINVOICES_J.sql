--חשבוניות ספק
SELECT
    item.value:IVNUM::string         AS IVNUM,
    item.value:PROJDOCNO::VARCHAR     AS PROJDOCNO,
    item.value:IVDATE::date          AS IVDATE,
    item.value:QPRICE::float         AS QPRICE,
    item.value:DISPRICE::float       AS DISPRICE,
    item.value:TOTPRICE::float       AS TOTPRICE,
    item.value:STORNOFLAG::string    AS STORNOFLAG,
    item.value:DEBIT::string         AS DEBIT,
    item.value:SUPNAME::string       AS SUPNAME,
    item.value:FINAL::string         AS FINAL,
    item.value:STATDES::string       AS STATDES,
    item.value:ORDNAME::string       AS ORDNAME,
    item.value:PAYDATE::date         AS PAYDATE,
    item.value:BALDDATE::date        AS BALDATE,
    SOURCE_DB::string                AS SOURCE_DB
FROM {{ source('json', 'YINVOICES') }},
LATERAL FLATTEN(input => DATA) item