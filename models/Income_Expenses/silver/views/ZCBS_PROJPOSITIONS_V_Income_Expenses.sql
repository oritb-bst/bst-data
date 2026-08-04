select
  	PROJECT_NAME as "מספר פרויקט",
	PROJECT_ID,
	POSITION_CODE AS "קוד תפקיד",
	POSITION_DES AS "תאור תפקיד",
    USER_NAME AS "מנהל אזור",
    a.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('ZCBS_PROJPOSITIONS_STG') }} a

{{ join_valid_projects('a.PROJECT_NAME', 'a.SOURCE_DB') }}

where POSITION_CODE = 33