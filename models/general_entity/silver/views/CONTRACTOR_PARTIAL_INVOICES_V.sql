select  
    PROJECT_ID          as "פרויקט_ID",
	PROJECT_NAME        as "מספר פרויקט",
	CONTRACTOR_NAME     as "שם קבלן",
	CONTRACTOR_DES      as "תיאור קבלן",
	PARTIAL_INVOICE_NUM as "מספר חשבון",
	CURDATE             as "Date",
    PRICE_AFTER_DISCOUNT_INV as "מחיר חשבון אחרי הנחה",
    STATUS_INV               as "סטטוס חשבון",
	SOURCE_DB           as "חברה"
from {{ ref('CONTRACTOR_PARTIAL_INVOICES') }}