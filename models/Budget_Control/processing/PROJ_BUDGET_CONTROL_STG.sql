select
    "PERIOD" as PERIOD_ID,
    DOC      as PROJECT_ID,
    CONMONTH as "MONTH",
    CONDATE  as DATE,
    CURVERSION,
    SOURCE_DB
from {{ source('bronze', 'BUD_CONTROLPERIODS_Z') }}