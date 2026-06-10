--PORDERS
select
    PROJECT_NAME as "מספר פרויקט",
	SUP_NAME     as "מספר ספק",
	CURDATE      as "Date",
	PRICE_AFTER_DIS_PORD as "מחיר הזמנת רכש אחרי הנחה",
	STATUS_PORD          as "סטטוס הזמנת רכש",
    PORDER_NAME          as "מספר הזמנת רכש",
	SOURCE_DB            as "חברה"
from {{ ref('PURCHASE_ORDERS') }} t

{{ join_valid_projects_buildup('t.PROJECT_NAME') }}