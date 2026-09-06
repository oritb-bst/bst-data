select
  	PROJECT_NAME as "מספר פרויקט",
	PROJECT_ID,
	POSITION_CODE AS "קוד תפקיד",
	POSITION_DES AS "תאור תפקיד",
    USER_NAME AS "מנהל אזור",
    a.SOURCE_DB  as "חברה"
from {{ ref('ZCBS_PROJPOSITIONS_STG') }} a

{{ join_valid_projects_project_managment('a.PROJECT_NAME', 'a.SOURCE_DB') }}

where POSITION_CODE = 33