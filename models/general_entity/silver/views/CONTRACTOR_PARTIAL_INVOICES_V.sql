--MED_DOCUMENTS_P
select  
	PROJECT_NAME        as "מספר פרויקט",
	SUP_NAME            as "מספר קבלן",
	PARTIAL_INVOICE_NUM as "מספר חשבון",
	CURDATE             as "Date",
    PRICE_AFTER_DISCOUNT_INV as "מחיר חשבון אחרי הנחה",
    STATUS_INV               as "סטטוס חשבון",
	SOURCE_DB           as "חברה"
from {{ ref('CONTRACTOR_PARTIAL_INVOICES') }}