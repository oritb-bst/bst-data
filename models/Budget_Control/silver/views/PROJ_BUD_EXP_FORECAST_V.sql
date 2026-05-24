--BUD_FORECAST
select 
    FORECAST_ID           as "צפי לגמר",
	USER_ID               as "משתמש",
	BUD_CONTROL_PERIOD_ID as "בקרה תקציבית_ID",
	CHAPTER_NAME          as "מספר פרק",
	CHAPTER_DES           as "תיאור פרק",
	SUB_CHAPTER_NAME      as "מספר תת פרק",
	SUB_CHAPTER_DES       as "תיאור תת פרק",
	SUB_TOPIC_NAME        as "מספר משאב",
	SUB_TOPIC_DES         as "תיאור משאב",
	ACTUAL_BUDGET_SPENT   as "ניצול בפועל",
	FORECAST_TO_COMPLETE  as "אומדן לגמר (הוצאות)",
	CURRENT_BUDGET        as "תקציב הוצאות עדכני",
	APPROVED_TO_PAY       as "מאושר לתשלום",
	PREVIOUS_FORECAST     as "אומדן קודם (הוצאות)",
    ORIGINAL_BUDGET       as "תקציב הוצאות מקורי",
    PROJECT_ID            as "מספר פרויקט",
	SOURCE_DB             as "חברה"
from {{ ref('PROJ_BUD_EXP_FORECAST') }}