SELECT
    PROJECT_NAME as "שם פרויקט",
	PROJECT_NUMBER as "מספר פרויקט",
	MONTH as "חודש",
	REVENUE as "הכנסות",
	EXPENSE as "הוצאות"
from {{ ref('WORK_PLAN_STG') }}
