select
  	a.DOCNO as "מספר פרויקט",
	DOC ,
	POSITIONCODE AS "קוד תפקיד",
	POSITIONDES AS "תאור תפקיד",
    USERNAME AS "מנהל אזור",
    a.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('ZCBS_PROJPOSITIONS') }} a

{{ join_valid_projects('a.DOCNO', 'a.SOURCE_DB') }}
