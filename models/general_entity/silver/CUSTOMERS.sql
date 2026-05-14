select 
 customer_id,
 customer_name,
 customer_description,
 SOURCE_DB
from {{ ref('CUSTOMERS_STG') }}