
select
    CUST as customer_id,
    CUSTNAME as customer_name,
    CUSTDES as customer_description
from {{ source('bronze', 'CUSTOMERS') }}