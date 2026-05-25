select  
    PROJECT_ID          as "פרויקט_ID",
	PROJECT_NAME        as "שם פרויקט",
	CONTRACTOR_NAME     as "שם קבלן",
	CONTRACTOR_DES      as "תיאור קבלן",
	PARTIAL_INVOICE_NUM as "מספר חשבון",
	DATE,
	SOURCE_DB           as "חברה"
from {{ ref('CONTRACTOR_PARTIAL_INVOICES') }}