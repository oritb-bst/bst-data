select
 *
from {{ source('bronze', 'ORDERS') }}