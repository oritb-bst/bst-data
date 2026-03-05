SELECT
    PROJECT_NAME as "שם פרויקט",
	PROJECT_NUMBER as "מספר פרויקט",
	MONTH as "חודש",
	REVENUE as "תוכנית עבודה הכנסות",
	EXPENSE as "תוכנית עבודה הוצאות"
from {{ ref('WORK_PLAN_STG') }}
