select 
    PROJECT_ID as "מספר פרויקט",
    VERSION_ID as "מספר מהדורה",
    VER_DATE   as "תאריך מהדורה",
	VER_DES    as "תיאור מהדורה",
	IS_ZERO_EDITION as "דגל מהדורת 0",
	IS_EXECUTED     as "דגל ביצוע",  
	SOURCE_DB       as "חברה"
from {{ ref('PROJ_BUD_VERSIONS') }}