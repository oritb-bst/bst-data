--ZCBS_PROJPOSITIONS_SUBFORM
--33 מנהל איזור
--55 בקר תקציב ישיר
select
    DOCNO,
    DOC,
    max(case when POSITIONCODE = 33 then POSITIONCODE end) as AREA_MANAGER_POSITIONCODE,
    max(case when POSITIONCODE = 33 then USERNAME end)     as AREA_MANAGER_USERNAME,
    max(case when POSITIONCODE = 55 then POSITIONCODE end) as DIRECT_BUDGET_CONTROLLER_POSITIONCODE,
    max(case when POSITIONCODE = 55 then USERNAME end)     as DIRECT_BUDGET_CONTROLLER_USERNAME,
    SOURCE_DB
from {{ ref('ZCBS_PROJPOSITIONS_J') }}
where POSITIONCODE in (33, 55)
  and SOURCE_DB = 'BLDUP'
group by DOCNO, DOC, SOURCE_DB