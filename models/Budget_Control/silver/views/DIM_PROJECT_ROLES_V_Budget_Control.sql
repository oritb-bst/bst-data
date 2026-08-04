select
  	PROJECT_NAME  as "מספר פרויקט",
	PROJECT_ID    as "פרויקט_ID",
	POSITION_CODE as "קוד תפקיד",
	POSITION_DES  as "תיאור תפקיד",
    USER_NAME     as "שם עובד",
    AREA_MANAGER_POSITIONCODE as "קוד מנהל איזור",
    AREA_MANAGER_USERNAME     as "מנהל איזור",
    PROJECT_MANAGER_POSITIONCODE as "קוד מנהל פרויקט",
    PROJECT_MANAGER_USERNAME     as "מנהל פרויקט", 
    t.SOURCE_DB  as "חברה"
from {{ ref('ZCBS_PROJPOSITIONS_STG') }} t

{{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}