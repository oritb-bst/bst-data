--ZCBS_PROJPOSITIONS_SUBFORM
select
  	t.DOCNO as "מספר פרויקט",
	DOC     as "פרויקט_ID",
	AREA_MANAGER_POSITIONCODE as "מספר מנהל איזור",
    AREA_MANAGER_USERNAME     as "מנהל איזור",
    DIRECT_BUDGET_CONTROLLER_POSITIONCODE as "מספר בקר תקציב ישיר",
    DIRECT_BUDGET_CONTROLLER_USERNAME     as "בקר תקציב ישיר",
    t.SOURCE_DB                           as "חברה"
from {{ ref('DIM_PROJECT_ROLES_Buildup') }} t

{{ join_valid_projects_buildup('t.DOCNO', 't.SOURCE_DB') }}