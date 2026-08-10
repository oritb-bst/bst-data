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
    GUARANTEED_ENTITY_NAME    as "שם הנערב",
    GUARANTEE_TYPE_NAME       as "מספר סוג ערבות",
    GUARANTEE_STATUS          as "סטטוס ערבות",
    GUARANTEE_PARTY           as "צד הערבות", --מזמין/קבלן
    GUARANTEE_NAME            as "מספר ערבות",
    SOURCE_DB                 as "חברה"
from {{ ref('GUARANTEES_STG') }}