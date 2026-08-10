--MEDR_GUARANTCHNGLOG_SUBFORM
select
    CHANGE_TYPE    as "סוג שינוי",
    PREV_VALUE     as "ערך ישן",
    NEW_VALUE      as "ערך חדש",
    STAT_IN_CHANGE as "סטטוס בזמן שינוי",
    CHANGE_DATE    as "תאריך שינוי",
    GUARANTEE_NAME as "מספר ערבות",
    SOURCE_DB      as "חברה"
from {{ ref('GUARANTEES_CHANGE_LOG_STG') }}