--BUD_FORECAST_R
select 
    FORECAST_ID                   as "צפי לגמר",
	BUD_CONTROL_PERIOD_ID         as "בקרה תקציבית_ID",
	SUB_CHAPTER_NAME              as "מספר תת פרק",
	SUB_CHAPTER_DES               as "תיאור תת פרק",
	REVENUE_FORECAST_TO_COMPLETE  as "אומדן לגמר (הכנסות)",
    CUSTOMER_ACCOUNT              as "חשבון מזמין שוטף",
	CURRENT_REVENUE_BUDGET        as "תקציב הכנסות עדכני",
	PREVIOUS_REVENUE_FORECAST     as "אומדן קודם (הכנסות)",
    ORIGINAL_REVENUE_BUDGET       as "תקציב הכנסות מקורי",
    PROJECT_ID                    as "מספר פרויקט",
	SOURCE_DB                     as "חברה"
from {{ ref('PROJ_BUD_INC_FORECAST') }}