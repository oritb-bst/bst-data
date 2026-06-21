--PROJACTS
select 
    PROJPLAN_ID       as "תכנון פעילות",
	PROJECT_ID        as "פרויקט_ID",
	VERSION_ID        as "מספר מהדורה",
	PROJPLAN_UID      as "תכנון פרויקט קוד ייחודי", 
	ACTIVITY_WBS_CODE as "מספר פעילות",
	ACTIVITY_NAME     as "שם פעילות",
	SUBMISSION_TOTAL_PRICE as "סך הכל מחיר הגשה",
	MATERIAL_COST          as "עלות חומר לפעילות",
--    BUD_SUBCHAPTER_NAME    as "מספר תת פרק",
    coalesce(SUB_CHAPTER_NAME, 'ללא') as "מספר תת פרק",
    BUD_SUBCHAPTER_DES     as "תיאור תת פרק",
    t.SOURCE_DB              as "חברה"
from {{ ref('PROJ_PLANNING') }} t

{{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}