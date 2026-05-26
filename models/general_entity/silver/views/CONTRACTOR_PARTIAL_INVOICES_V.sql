--MED_DOCUMENTS_P
select  
	PROJECT_NAME        as "מספר פרויקט",
<<<<<<< HEAD
	SUP_NAME            as "מספר קבלן",
=======
	SUP_NAME            as "מספר ספק",
>>>>>>> 498ef3077a0f51310777349d128e35c8a0d7c7a3
	PARTIAL_INVOICE_NUM as "מספר חשבון",
	CURDATE             as "Date",
    PRICE_AFTER_DISCOUNT_INV as "מחיר חשבון אחרי הנחה",
    STATUS_INV               as "סטטוס חשבון",
	SOURCE_DB           as "חברה"
from {{ ref('CONTRACTOR_PARTIAL_INVOICES') }}