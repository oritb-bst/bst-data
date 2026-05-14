select 
 customer_id as "לקוח",
 customer_name as "מזמין",
 customer_description as "תאור מזמין",
 SOURCE_DB  as "חברה"
from {{ ref('CUSTOMERS') }}