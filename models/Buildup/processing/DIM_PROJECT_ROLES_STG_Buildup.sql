--ZCBS_PROJPOSITIONS_SUBFORM
--33 מנהל איזור
--42 בקר התקשרויות בילדאפ
select
    DOCNO,
    DOC,
    max(case when POSITIONCODE = 33 then POSITIONCODE end) as AREA_MANAGER_POSITIONCODE,
    max(case when POSITIONCODE = 33 then USERNAME end)     as AREA_MANAGER_USERNAME,
    max(case when POSITIONCODE = 42 then POSITIONCODE end) as BLDUP_CONTRACT_CONTROLLER_POSITIONCODE,
    max(case when POSITIONCODE = 42 then USERNAME end)     as BLDUP_CONTRACT_CONTROLLER_USERNAME,
    SOURCE_DB
from {{ ref('ZCBS_PROJPOSITIONS_J') }}
where POSITIONCODE in (33, 42)
  and SOURCE_DB = 'BLDUP'
group by DOCNO, DOC, SOURCE_DB