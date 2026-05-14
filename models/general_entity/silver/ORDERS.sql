select
    ORD,
    CUSTNAME, 
    ORDNAME,
    SOURCE_DB
from {{ ref('ORDERS_STG') }}
