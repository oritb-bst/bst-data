select
  	DOCNO as "מספר פרויקט",
	DOC ,
	POSITIONCODE AS "קוד תפקיד",
	POSITIONDES AS "תאור תפקיד",
    USERNAME AS "מנהל אזור"
from {{ ref('ZCBS_PROJPOSITIONS_STG') }}
