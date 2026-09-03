--PROJACTS
select 
    PROJECT_NAME      as "מספר פרויקט",
    PROJPLAN_ID       as "תכנון פעילות",
	PROJECT_ID        as "פרויקט_ID",
	VERSION_ID        as "מספר מהדורה",
	PROJPLAN_UID      as "תכנון פרויקט קוד ייחודי", 
	ACTIVITY_WBS_CODE as "מספר פעילות",
	ACTIVITY_NAME     as "שם פעילות",
	SUBMISSION_TOTAL_PRICE as "סך הכל מחיר הגשה",
	MATERIAL_COST          as "עלות חומר לפעילות",
--    BUD_SUBCHAPTER_NAME    as "מספר תת פרק",
    coalesce(BUD_SUBCHAPTER_NAME, 'ללא') as "מספר תת פרק",
    BUD_SUBCHAPTER_DES as "תיאור תת פרק",
    CHAPTER_NAME       as "מספר פרק",
    PRICE_PER_UNIT     as "מחיר ליחידה",
    COST_PER_UNIT      as "עלות ליחידה",
    t.SOURCE_DB        as "חברה"
from {{ ref('PROJ_PLANNING_STG_NEW') }} t

{{ join_bst_projects_budget_control('PROJECT_NAME', 't.SOURCE_DB') }}