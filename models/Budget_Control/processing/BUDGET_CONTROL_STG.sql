select
    PERIOD,
    DOC as PROJECT_ID,
    CONMONTH as MONTH,
    CONDATE  as DATE,
    CURVERSION
from {{ source('bronze', 'BUD_CONTROLPERIODS_Z') }}