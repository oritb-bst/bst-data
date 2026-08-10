--MEDR_GUARANTCHNGLOG_SUBFORM
select
    CHNGTYPE  as CHANGE_TYPE, --סוג שינוי
    PREVVALUE as PREV_VALUE, --ערך ישן
    NEWVALUE  as NEW_VALUE, --ערך חדש
    STATDES   as STAT_IN_CHANGE, --סטטוס בזמן שינוי
    UDATE     as CHANGE_DATE, --תאריך שינוי
    DOCNO     as GUARANTEE_NAME, --מספר ערבות
    SOURCE_DB
from {{ ref('MEDR_GUARANTCHNGLOG_J') }}