SELECT
    CUST as customer_id,
    CUSTNAME as customer_name,
    CUSTDES as customer_description,
    SOURCE_DB
FROM {{ ref('CUSTOMERS') }}
