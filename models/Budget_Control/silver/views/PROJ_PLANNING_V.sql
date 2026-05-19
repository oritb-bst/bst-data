--PROJACTS
select 
    PROJPLAN_ID       as "תכנון פעילות",
	PROJECT_ID        as "פרויקט_ID",
	VERSION_ID        as "מספר מהדורה",
	PROJPLAN_UID      as "תכנון פרויקט קוד ייחודי", 
	ACTIVITY_WBS_CODE as "מספר פעילות",
	ACTIVITY_NAME     as "שם פעילות",
	SUBMISSION_TOTAL_PRICE as "סך הכל מחיר  הגשה",
	MATERIAL_COST          as "עלות חומר לפעילות",
    SOURCE_DB              as "חברה"
from {{ ref('PROJ_PLANNING') }}