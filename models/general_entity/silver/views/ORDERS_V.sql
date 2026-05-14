select
    ORD  ,
    CUSTNAME  as "מזמין" , 
    ORDNAME AS "חוזה מזמין",
    SOURCE_DB  as "חברה"
from {{ ref('ORDERS') }}
