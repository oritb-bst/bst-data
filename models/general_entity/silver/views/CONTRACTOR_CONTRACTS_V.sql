--MED_PORDERS
select 
	PROJECT_NAME    as "מספר פרויקט",
	SUP_NAME        as "מספר קבלן",
	SUP_DES         as "תיאור קבלן",
	PRICETOAPP      as "מצטבר חוזה",
	MED_TYPE        as "סוג חוזה",
	PRICE_AFTER_DIS_CON as "מחיר חוזה אחרי הנחה",
	CURDATE         as "Date",
    ORDER_NAME      as "מספר הזמנה",
    MED_TYPE_DESC   as "תיאור סוג חוזה",
    STATUS_CON      as "סטטוס חוזה",
	SOURCE_DB       as "חברה"
from {{ ref('CONTRACTOR_CONTRACTS') }}