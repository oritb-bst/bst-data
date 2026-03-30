select
    ORD  ,
    CUSTNAME  as "מזמין" , 
    ORDNAME AS "חוזה מזמין"
from {{ ref('ORDERS_STG') }}
