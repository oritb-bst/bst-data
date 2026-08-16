--MEDR_GUARANTEES

--הקטנה ב3 חודשים האחרונים
with decrease_per_guarantee as (
    select
        GUARANTEE_NAME,
        SOURCE_DB,
        max(CHANGE_DATE) as LAST_DECREASE_DATE
    from {{ ref('GUARANTEES_CHANGE_LOG_STG') }}
    where IS_DECREASE = 1
    group by GUARANTEE_NAME, SOURCE_DB
)

select
    g.PROJECT_NAME as "מספר פרויקט",
    g.PROJECT_DES  as "שם פרויקט",
    g.BANK_NAME    as "שם בנק",
    g.GUARANTEE_TYPE_DES        as "תיאור סוג ערבות",
    g.BANK_GUARANTEE_REFERENCE  as "מספר הערבות בבנק",
    g.ACC_DES                   as "שם לקוח/ספק מקורי",
    g.GUARANTEE_AMOUNT          as "סכום ערבות",
    g.REVALUED_GUARANTEE_AMOUNT as "ערבות משוערכת",
    g.GUARANTEE_START_DATE      as "תאריך תחילת ערבות",
    g.GUARANTEE_END_DATE        as "תאריך תוקף מעודכן",
    g.GUARANTEED_ENTITY_NAME    as "שם הנערב",
    g.GUARANTEE_TYPE_NAME       as "מספר סוג ערבות",
    g.GUARANTEE_STATUS          as "סטטוס ערבות",
    g.GUARANTEE_PARTY           as "צד הערבות",
    g.GUARANTEE_NAME            as "מספר ערבות",
    g.SOURCE_DB                 as "חברה",

    d.LAST_DECREASE_DATE        as "תאריך הקטנה אחרון",

    case
        when d.LAST_DECREASE_DATE is null then 0
        when d.LAST_DECREASE_DATE < dateadd(month, -3, current_date()) then 1 else 0 end as "לא היתה הקטנה ב-3 חודשים"
from {{ ref('GUARANTEES_STG') }} g

left join decrease_per_guarantee d
    on g.GUARANTEE_NAME = d.GUARANTEE_NAME
   and g.SOURCE_DB = d.SOURCE_DB