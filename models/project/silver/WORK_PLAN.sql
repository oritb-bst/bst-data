SELECT
    PROJECT_NAME as "שם פרויקט",
	PROJECT_NUMBER as "מספר פרויקט",
	MONTH_YEAR as "Date",
	REVENUE as "תוכנית עבודה הכנסות",
	EXPENSE as "תוכנית עבודה הוצאות"
from {{ ref('WORK_PLAN_STG') }}
