--PORDERS
select
    a.PROJECT_NAME as "מספר פרויקט",
	SUP_NAME     as "מספר ספק",
	CURDATE      as "Date",
	PRICE_AFTER_DIS_PORD as "מחיר הזמנת רכש אחרי הנחה",
	STATUS_PORD          as "סטטוס הזמנת רכש",
    PORDER_NAME          as "מספר הזמנת רכש",
	a.SOURCE_DB            as "חברה"
from {{ ref('PURCHASE_ORDERS_STG') }} a

{{ join_valid_projects_project_managment('a.PROJECT_NAME', 'a.source_db') }}