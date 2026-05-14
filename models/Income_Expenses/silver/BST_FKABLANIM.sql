select    
    id,
    "FOREX", 
	order_name,
	supplier_desc,
	supplier_name,
	details,
	prevalue,
	book_num,
	status_desc,
	price,
    uninvoiced_amount,
    net_amount,
    total_invoice_amount,
	pay_date,
    source_db
    
from {{ ref('BST_FKABLANIM_STG') }}
