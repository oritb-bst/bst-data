select 
    PROJECT_ID      as "פרויקט_ID",
	PROJECT_NAME    as "מספר פרויקט",
	CONTRACTOR_NAME as "שם קבלן",
	CONTRACTOR_DES  as "תיאור קבלן",
	PRICETOAPP      as "מצטבר חוזה",
	MED_TYPE        as "סוג חוזה",
	PRICE_AFTER_DIS as "מחיר אחרי הנחה",
	CURDATE         as "Date",
    ORDER_NAME      as "שם הזמנה",
    MED_TYPE_DESC   as "תיאור סוג חוזה",
	SOURCE_DB       as "חברה"
from {{ ref('CONTRACTOR_CONTRACTS') }}