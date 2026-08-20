--BUD_FORECAST
select 
    PROJECT_NAME          as "מספר פרויקט",
    FORECAST_ID           as "צפי לגמר",
	USER_ID               as "משתמש",
	BUD_CONTROL_PERIOD_ID as "בקרה תקציבית_ID",
	CHAPTER_NAME          as "מספר פרק",
	CHAPTER_DES           as "תיאור פרק",
	--SUB_CHAPTER_NAME      as "מספר תת פרק",
    coalesce(SUB_CHAPTER_NAME, 'ללא') as "מספר תת פרק",
	SUB_CHAPTER_DES       as "תיאור תת פרק",
	SUB_TOPIC_NAME        as "מספר משאב",
	SUB_TOPIC_DES         as "תיאור משאב",
	ACTUAL_BUDGET_SPENT   as "ניצול בפועל",
    ACTUAL_BUDGET_SPENT_K as "ניצול בפועל באלפי שח",
	FORECAST_TO_COMPLETE  as "אומדן לגמר (הוצאות)",
    FORECAST_TO_COMPLETE_K  as "אומדן לגמר (הוצאות) באלפי שח",
	CURRENT_BUDGET        as "תקציב הוצאות עדכני",
    CURRENT_BUDGET_K      as "תקציב הוצאות עדכני באלפי שח",
	APPROVED_TO_PAY       as "מאושר לתשלום",
    APPROVED_TO_PAY_K     as "מאושר לתשלום באלפי שח",
	PREVIOUS_FORECAST     as "אומדן קודם (הוצאות)",
    PREVIOUS_FORECAST_K   as "אומדן קודם (הוצאות) באלפי שח",
    ORIGINAL_BUDGET       as "תקציב הוצאות מקורי",
    ORIGINAL_BUDGET_K     as "תקציב הוצאות מקורי באלפי שח",
    PROJECT_ID            as "פרויקט_ID",
    BUD_CONTROL_DATE      as "Date",
    TOPIC_NAME            as "מספר נושא",
    TOPIC_DES             as "תיאור נושא",
	t.SOURCE_DB           as "חברה"
from {{ ref('PROJ_BUD_EXP_FORECAST_STG') }} t

{{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}

