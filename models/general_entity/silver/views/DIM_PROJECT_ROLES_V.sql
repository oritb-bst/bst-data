select
  	PROJECT_NAME as "מספר פרויקט",
	PROJECT_ID,
	POSITION_CODE as "קוד תפקיד",
	POSITION_DES as "תיאור תפקיד",
    USER_NAME as "שם עובד",
    SOURCE_DB  as "חברה"
from {{ ref('ZCBS_PROJPOSITIONS_STG') }}
