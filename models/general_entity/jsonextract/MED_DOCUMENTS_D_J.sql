--חשבון חלקי מזמין (MED_DOCUMENTS_D) 

SELECT
    item.value:DOC::number                AS DOC,
    item.value:MED_EXEMONTH::string       AS MED_EXEMONTH,
    item.value:PROJDOCNO::string          AS PROJDOCNO,
    item.value:ORDNAME::string            AS ORDNAME,
    item.value:CUSTNAME::string           AS CUSTNAME,
    item.value:DISPRICE::float            AS DISPRICE,
    item.value:EXPECTPAY ::float          AS EXPECTPAY ,
    item.value:STATDES::string            AS STATDES,
    item.value:BOOKNUM::string            AS BOOKNUM,
    SOURCE_DB::string                     AS SOURCE_DB

FROM {{ source('json', 'MED_DOCUMENTS_D') }},
LATERAL FLATTEN(input => DATA) item