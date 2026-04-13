select    
    id as "תחזית פרויקט ID",
	order_name as "חוזה קבלן",
	supplier_desc as "שם קבלן",
	supplier_name as "מספר קבלן",
	details as "נושא",
	prevalue as "הערכת טרום תקופה",
	book_num as "מספר חשבון חלקי קבלן",
	status_desc as "סטטוס החשבון",
	price as "מחיר כולל",
	pay_date as "Date"
from {{ ref('FORECAST_SUB_CONTRACT_STG') }}
