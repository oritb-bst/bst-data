--BUD_FORECAST_R
select 
    FORECAST_ID                   as "צפי לגמר",
	BUD_CONTROL_PERIOD_ID         as "בקרה תקציבית_ID",
--	SUB_CHAPTER_NAME              as "מספר תת פרק",
    coalesce(SUB_CHAPTER_NAME, 'ללא') as "מספר תת פרק",
	SUB_CHAPTER_DES               as "תיאור תת פרק",
	REVENUE_FORECAST_TO_COMPLETE  as "אומדן לגמר (הכנסות)",
    CUSTOMER_ACCOUNT              as "חשבון מזמין שוטף",
	CURRENT_REVENUE_BUDGET        as "תקציב הכנסות עדכני",
	PREVIOUS_REVENUE_FORECAST     as "אומדן קודם (הכנסות)",
    ORIGINAL_REVENUE_BUDGET       as "תקציב הכנסות מקורי",
    PROJECT_ID                    as "פרויקט_ID",
    BUD_CONTROL_DATE              as "Date",
	t.SOURCE_DB                   as "חברה"
from {{ ref('PROJ_BUD_INC_FORECAST') }} t

{{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}