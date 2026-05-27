--SUPPLIERS
select
    SUP_ID   as "ספק_ID",
	SUP_NAME as "מספר ספק",
	SUP_DES  as "תיאור ספק",
    SUP_TYPE_CODE as "סוג ספק",
    SUP_TYPE_DES  as "תיאור סוג ספק",
	SOURCE_DB as "חברה"
from {{ ref('DIM_SUPPLIERS') }}