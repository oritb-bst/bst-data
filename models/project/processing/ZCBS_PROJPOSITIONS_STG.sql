select
 *
from {{ source('bronze', 'ZCBS_PROJPOSITIONS') }}
where POSITIONCODE = 33