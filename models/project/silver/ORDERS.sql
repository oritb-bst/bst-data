select
    ORD  ,
    CUSTNAME , 
from {{ ref('ORDERS_STG') }}
