select
    item.value:DOCNO::string          as DOCNO,
    item.value:PROJ::string           as PROJ,
    item.value:CUSTNAME::string       as CUSTNAME,
    item.value:MED_PAYDES::string     as MED_PAYDES,
    item.value:MED_TYPE::string       as MED_TYPE,
    item.value:TOTPRICE::float        as TOTPRICE,
    item.value:CURDATE::date          as CURDATE,
    item.value:ORDSTATUSDES::string   as ORDSTATUSDES,
    SOURCE_DB::string                 as SOURCE_DB

from {{ source('json', 'MED_ORDERS') }},
lateral flatten(input => DATA) item