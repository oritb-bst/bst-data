select
    PERIOD,
    DOC as Project_ID,
    CONMONTH as Month,
    CONDATE  as Date,
    CURVERSION as CurrVersion
from {{ source('bronze', 'BUD_CONTROLPERIODS_Z') }}