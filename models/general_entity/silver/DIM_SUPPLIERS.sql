--SUPPLIERS
select
    SUP_ID,
	SUP_NAME,
	SUP_DES,
	SOURCE_DB
from {{ ref('DIM_SUPPLIERS_STG') }}