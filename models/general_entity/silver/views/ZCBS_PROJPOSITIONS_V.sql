select
  	DOCNO as "מספר פרויקט",
	DOC ,
	POSITIONCODE AS "קוד תפקיד",
	POSITIONDES AS "תאור תפקיד",
    USERNAME AS "מנהל אזור",
    SOURCE_DB  as "חברה"
from {{ ref('ZCBS_PROJPOSITIONS') }}
