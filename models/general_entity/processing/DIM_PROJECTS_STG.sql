select
 *
from {{ source('bronze', 'DIM_PROJECTS') }}