--PORDERS
select
    PROJECT_NAME as "מספר פרויקט",
	SUP_NAME     as "מספר ספק",
	CURDATE      as "Date",
	PRICE_AFTER_DIS_PORD as "מחיר הזמנת רכש אחרי הנחה",
	STATUS_PORD          as "סטטוס הזמנת רכש",
    PORDER_NAME          as "מספר הזמנת רכש",
	t.SOURCE_DB          as "חברה"
from {{ ref('PURCHASE_ORDERS_STG') }} t

{{ join_bst_projects_budget_control('PROJECT_NAME', 't.SOURCE_DB') }}

and STATUS_PORD not in ('מבוטלת', 'נדחתה') --סטטוס הזמנת רכש