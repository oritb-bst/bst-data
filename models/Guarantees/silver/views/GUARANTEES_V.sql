--MEDR_GUARANTEES
select
    PROJECT_NAME as "מספר פרויקט",
    PROJECT_DES  as "שם פרויקט",
    BANK_NAME    as "שם בנק",
    GUARANTEE_TYPE_DES        as "תיאור סוג ערבות",
    BANK_GUARANTEE_REFERENCE  as "מספר הערבות בבנק",
    ACC_DES                   as "שם לקוח/ספק מקורי",
    GUARANTEE_AMOUNT          as "סכום ערבות",
    REVALUED_GUARANTEE_AMOUNT as "ערבות משוערכת",
    GUARANTEE_START_DATE      as "תאריך תחילת ערבות",
    GUARANTEE_END_DATE        as "תאריך תוקף מעודכן",
    SOURCE_DB                 as "חברה",
    CASE
    WHEN SOURCE_DB = 'BST' THEN 'בסט'
    WHEN SOURCE_DB = 'BLDUP' THEN 'בילדאפ'
    ELSE SOURCE_DB END AS SOURCE_DB_DESCRIPTION 
from {{ ref('GUARANTEES') }}