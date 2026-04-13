select    
    FORECAST as id,
	ORDNAME as order_name,
	SUPNAME as supplier_desc,
	SUPDES as supplier_name,
	DETAILS as details,
	PREVALUE as prevalue,
	BOOKNUM as book_num,
	STATDES as status_desc,
	QPRICE as price,
	PAYDATE as pay_date
from {{ source('bronze', 'FORECAST_SUB_CONTRACT') }}


	