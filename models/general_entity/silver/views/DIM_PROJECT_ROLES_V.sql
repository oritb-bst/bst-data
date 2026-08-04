select
  	PROJECT_NAME as "מספר פרויקט",
	PROJECT_ID,
	POSITIONCODE as "קוד תפקיד",
	POSITIONDES as "תיאור תפקיד",
    USERNAME as "שם עובד",
    SOURCE_DB  as "חברה"
from {{ ref('ZCBS_PROJPOSITIONS_STG') }}
