select
    t.PROJECT_NAME   as "מספר פרויקט",                               
    BUD_CONTROL_DATE as "Date",
    DOCCODE          as "סוג תעודה",
    SUP_NAME         as "מספר ספק",
    CONTRACT_REDUCTION as "קיזוז חוזי",
    MANUAL_REDUCTION   as "קיזוז ידני",
    t.SOURCE_DB
from {{ ref('CONTRACTOR_REDUCTIONS_STG') }} t

{{ join_valid_projects('t.PROJECT_NAME', 't.SOURCE_DB') }}