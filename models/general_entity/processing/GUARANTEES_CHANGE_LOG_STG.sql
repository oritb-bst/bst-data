--הטבלה הזאת לטובת בדיקה האם היתה הקטנה בסכום הערבות לערבויות מאושרות
-- MEDR_GUARANTCHNGLOG_SUBFORM
select
    CHNGTYPE                 as CHANGE_TYPE, --סוג שינוי
    TRY_TO_NUMBER(PREVVALUE) as PREV_VALUE, --ערך ישן
    TRY_TO_NUMBER(NEWVALUE)  as NEW_VALUE, --ערך חדש
    STATDES                  as STAT_IN_CHANGE, --סטטוס בזמן שינוי
    TO_DATE(UDATE)           as CHANGE_DATE, --תאריך שינוי
    DOCNO                    as GUARANTEE_NAME, --מספר ערבות
    SOURCE_DB,
    case when TRY_TO_NUMBER(NEWVALUE) < TRY_TO_NUMBER(PREVVALUE) then 1 else 0 end as IS_DECREASE
from {{ ref('MEDR_GUARANTCHNGLOG_J') }}
where CHNGTYPE = 'סכום ערבות'
  and TRY_TO_NUMBER(PREVVALUE) <> 0.00
  and STATDES = 'מאושרת'