select 
    PROJECT_NUMBER as "מספר פרויקט",
    EXPENSES_DATE  as "Date",
    EXPENSES_DESCRIPTION as "תאור הוצאות ידני",
	EXPENSES_LINE_CODE as "קוד תנועה",
	EXPENSES_TYPE as "שיוך",
	EXPENSES_AMOUNT as "סכום הוצאות ידני",
    EXPENSES_QTY as "כמות הוצאות ידני"
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('MANUAL_EXPENSES_STG') }} a

{{ join_valid_projects('a.PROJECT_NUMBER') }}


