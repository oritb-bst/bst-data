select
  	PROJECT_NAME as "מספר פרויקט",
	PROJECT_ID,
	POSITION_CODE AS "קוד תפקיד",
	POSITION_DES AS "תאור תפקיד",
    USER_NAME AS "מנהל אזור",
    SOURCE_DB  as "חברה"
from {{ ref('ZCBS_PROJPOSITIONS_STG') }} a


where POSITION_CODE = 33