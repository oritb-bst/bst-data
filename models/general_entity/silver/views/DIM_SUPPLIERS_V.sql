--SUPPLIERS
select
    SUP_ID   as "ספק_ID",
	SUP_NAME as "מספר קבלן",
	SUP_DES  as "תיאור קבלן",
	SOURCE_DB as "חברה"
from {{ ref('DIM_SUPPLIERS') }}