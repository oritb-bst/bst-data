--PROJVERSIONS
select 
    PROJECT_ID as "פרויקט_ID",
    VERSION_ID as "מספר מהדורה",
    VER_DATE   as "תאריך מהדורה",
	VER_DES    as "תיאור מהדורה",
	IS_ZERO_EDITION as "דגל מהדורת 0",
	IS_EXECUTED     as "דגל ביצוע",  
	t.SOURCE_DB       as "חברה"
from {{ ref('PROJ_BUD_VERSIONS') }} t

{{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}