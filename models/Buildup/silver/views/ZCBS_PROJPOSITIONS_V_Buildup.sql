select
  	t.DOCNO as "מספר פרויקט",
	DOC   as "פרויקט_ID",
	AREA_MANAGER_POSITIONCODE as "מספר מנהל איזור",
    AREA_MANAGER_USERNAME     as "מנהל איזור",
    BLDUP_CONTRACT_CONTROLLER_POSITIONCODE as "מספר בקר התקשרויות בילדאפ",
    BLDUP_CONTRACT_CONTROLLER_USERNAME     as "בקר התקשרויות בילדאפ",
    t.SOURCE_DB                              as "חברה"
from {{ ref('ZCBS_PROJPOSITIONS_Buildup') }} t

{{ join_valid_projects_buildup('t.DOCNO', 't.SOURCE_DB') }}