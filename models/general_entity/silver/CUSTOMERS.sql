select 
 customer_id as "לקוח",
 customer_name as "מזמין",
 customer_description as "תאור מזמין"
from {{ ref('CUSTOMERS_STG') }}