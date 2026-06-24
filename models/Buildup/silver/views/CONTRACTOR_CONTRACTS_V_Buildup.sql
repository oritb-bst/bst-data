--MED_PORDERS
select 
	PROJECT_NAME    as "מספר פרויקט",
	SUP_NAME        as "מספר ספק",
	SUP_DES         as "תיאור ספק",
	PRICETOAPP      as "מצטבר חוזה",
	MED_TYPE        as "סוג חוזה",
	PRICE_AFTER_DIS_CON as "מחיר חוזה אחרי הנחה",
	CURDATE         as "Date",
    ORDER_NAME      as "מספר הזמנה",
    MED_TYPE_DESC   as "תיאור סוג חוזה",
    STATUS_CON      as "סטטוס חוזה",
    PORD_ID         as "חוזה_ID",
	t.SOURCE_DB     as "חברה"
from {{ ref('CONTRACTOR_CONTRACTS') }} t

{{ join_valid_projects_buildup('t.PROJECT_NAME', 't.SOURCE_DB') }}

where {{ filter_last_n_years('t.CURDATE') }} --סינון שנים