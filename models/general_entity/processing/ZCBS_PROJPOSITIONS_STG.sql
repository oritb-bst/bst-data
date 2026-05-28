select
 *
from {{ ref ('ZCBS_PROJPOSITIONS_J') }}
where POSITIONCODE = 33