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
    uninvoiced_amount as "טרם הופק חשבון",
    net_amount as "הקטנה",
    total_invoice_amount as "סך החשבון",
	pay_date as  "תאריך ת. תשלום"
    
from {{ ref('BST_FKABLANIM_STG') }}
