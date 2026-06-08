select
  	t.DOCNO as "מספר פרויקט",
	DOC ,
	POSITIONCODE AS "קוד תפקיד",
	POSITIONDES AS "תאור תפקיד",
    USERNAME AS "מנהל אזור",
    t.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('ZCBS_PROJPOSITIONS') }} t

{{ join_valid_projects('t.DOCNO') }}
where t.SOURCE_DB = 'BST'


