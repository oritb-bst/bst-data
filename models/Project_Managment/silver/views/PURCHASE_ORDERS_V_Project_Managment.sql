--PORDERS
select
    a.PROJECT_NAME as "מספר פרויקט",
	SUP_NAME     as "מספר ספק",
	CURDATE      as "Date",
	PRICE_AFTER_DIS_PORD as "מחיר הזמנת רכש אחרי הנחה",
	STATUS_PORD          as "סטטוס הזמנת רכש",
    PORDER_NAME          as "מספר הזמנת רכש",
    TYPECODE             as "קוד סוג הזמנה",
    TYPEDES              as "תאור סוג הזמנה",
	a.SOURCE_DB          as "חברה" 
from {{ ref('PURCHASE_ORDERS_STG') }} a

{{ join_valid_projects_BST_BUILDUP('a.PROJECT_NAME', 'a.source_db') }}

where {{ filter_last_n_years('CURDATE') }} --סינון שנים