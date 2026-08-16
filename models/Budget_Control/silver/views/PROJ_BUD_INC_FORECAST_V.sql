--BUD_FORECAST_R
select 
    FORECAST_ID                   as "צפי לגמר",
	BUD_CONTROL_PERIOD_ID         as "בקרה תקציבית_ID",
--	SUB_CHAPTER_NAME              as "מספר תת פרק",
    coalesce(SUB_CHAPTER_NAME, 'ללא') as "מספר תת פרק",
	SUB_CHAPTER_DES               as "תיאור תת פרק",
	REVENUE_FORECAST_TO_COMPLETE  as "אומדן לגמר (הכנסות)",
    REVENUE_FORECAST_TO_COMPLETE_K  as "אומדן לגמר (הכנסות) באלפי שח",
    CUSTOMER_ACCOUNT              as "חשבון מזמין שוטף",
    CUSTOMER_ACCOUNT_K            as "חשבון מזמין שוטף באלפי שח",
	CURRENT_REVENUE_BUDGET        as "תקציב הכנסות עדכני",
    CURRENT_REVENUE_BUDGET_K      as "תקציב הכנסות עדכני באלפי שח",
	PREVIOUS_REVENUE_FORECAST     as "אומדן קודם (הכנסות)",
    PREVIOUS_REVENUE_FORECAST_K   as "אומדן קודם (הכנסות) באלפי שח",
    ORIGINAL_REVENUE_BUDGET       as "תקציב הכנסות מקורי",
    ORIGINAL_REVENUE_BUDGET_K     as "תקציב הכנסות מקורי באלפי שח",
    PROJECT_ID                    as "פרויקט_ID",
    BUD_CONTROL_DATE              as "Date",
	t.SOURCE_DB                   as "חברה"
from {{ ref('PROJ_BUD_INC_FORECAST_STG') }} t

{{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}