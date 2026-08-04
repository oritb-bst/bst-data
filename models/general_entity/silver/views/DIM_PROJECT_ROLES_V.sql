select
  	DOCNO as "מספר פרויקט",
	DOC,
	POSITIONCODE as "קוד תפקיד",
	POSITIONDES as "תיאור תפקיד",
    USERNAME as "שם עובד",
    SOURCE_DB  as "חברה"
from {{ ref('ZCBS_PROJPOSITIONS_STG') }}
