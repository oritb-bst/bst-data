select *
from {{ source('bronze', 'CUSTOMERS') }}