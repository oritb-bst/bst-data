select 
    Project as "מספר פרויקט",
    Exec_Month_Date  as "Date",
    EXPENSES_DESCRIPTION as "תאור הוצאות ידני",
	EXPENSES_LINE_CODE as "קוד תנועה",
	EXPENSES_TYPE as "סוג הוצאה",
	EXPENSES_AMOUNT as "סכום הוצאות ידני",
    EXPENSES_QTY as "כמות הוצאות ידני"
from {{ ref('MANUAL_EXPENSES_STG') }} 




