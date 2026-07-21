SELECT
    item.value:MED_EXEMONTH::string       AS MED_EXEMONTH,
    item.value:DOCNO::string              AS DOCNO,
    item.value:ORDNAME::string            AS ORDNAME,
    item.value:CUSTNAME::string           AS CUSTNAME,
    item.value:DISPRICE::float            AS DISPRICE,
    item.value:MED_APPQPRICE::float       AS MED_APPQPRICE,
    item.value:EXPECTPAY ::float          AS EXPECTPAY ,
    item.value:STATDES::string            AS STATDES,
    item.value:BOOKNUM::string            AS BOOKNUM,
    SOURCE_DB::string                     AS SOURCE_DB

FROM {{ source('json', 'MED_DOCUMENTS_D') }},
LATERAL FLATTEN(input => DATA) item