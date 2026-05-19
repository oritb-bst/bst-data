--DOCUMENTS_p
select
 *
from {{ source('bronze', 'DIM_PROJECTS') }}