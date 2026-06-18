SELECT
    PROJECT_NAME as "שם פרויקט",
	PROJECT_NUMBER as "מספר פרויקט",
	MONTH_WORK_PLAN as "Date",
	REVENUE as "תוכנית עבודה הכנסות",
	EXPENSE as "תוכנית עבודה הוצאות",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('WORK_PLAN') }} a

{{ join_valid_projects('a.PROJECT_NUMBER') }}
