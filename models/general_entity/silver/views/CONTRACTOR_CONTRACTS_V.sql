select 
    PROJECT_ID      as "פרויקט_ID",
	PROJECT_NAME    as "שם פרויקט",
	CONTRACTOR_NAME as "שם קבלן",
	CONTRACTOR_DES  as "תיאור קבלן",
	PRICETOAPP      as "מצטבר חוזה",
	MED_TYPE        as "סוג חוזה",
	PRICE_AFTER_DIS as "מחיר אחרי הנחה",
	DATE,
    ORDER_NAME      as "שם הזמנה",
	SOURCE_DB       as "חברה"
from {{ ref('CONTRACTOR_CONTRACTS') }}