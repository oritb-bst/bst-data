select
    ORD  ,
    CUSTNAME , 
    ORDNAME,
from {{ ref('ORDERS_STG') }}
