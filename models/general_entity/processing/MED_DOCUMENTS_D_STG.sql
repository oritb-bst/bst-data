--MED_DOCUMENTS_D
--מודול מזמין
SELECT
    TRY_TO_DATE('01/' || MED_EXEMONTH, 'DD/MM/YY') AS execution_date,
    DOCNO as PROJECT_DOCNO,
    ORDNAME,
    CUSTNAME,
    DISPRICE,
    MED_APPQPRICE,
    EXPECTPAY ,
    STATDES,
    BOOKNUM,
    SOURCE_DB

FROM {{ ref('MED_DOCUMENTS_D_J') }}

