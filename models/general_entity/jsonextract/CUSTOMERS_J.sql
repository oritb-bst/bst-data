SELECT
    item.value:CUST::string        as CUST,
    item.value:CUSTNAME::string    as CUSTNAME,
    item.value:CUSTDES::string     as CUSTDES,
    SOURCE_DB::string              as SOURCE_DB

FROM {{ source('json', 'CUSTOMERS') }},
lateral flatten(input => DATA) item

