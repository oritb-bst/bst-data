with base as (

select
    *,
    case when QPRICE is null or QPRICE=0 then PREVALUE else 0 end as UNINVOICED_AMOUNT_SAFE
from {{ source('bronze', 'BST_FKABLANIM') }}

)

select
    cast(FKABLANIM as varchar) as ID,
    ORDNAME as ORDER_NAME,
    SUPNAME as SUPPLIER_NAME,
    SUPDES as SUPPLIER_DESC,
    DETAILS,
    FOREX,
    PREVALUE,
    BOOKNUM as BOOK_NUM,
    STATDES as STATUS_DESC,
    QPRICE as PRICE,
    PAYDATE as PAY_DATE,

    QPRICE + UNINVOICED_AMOUNT_SAFE as total_invoice_amount,

    PREVALUE - QPRICE - UNINVOICED_AMOUNT_SAFE as net_amount,

    case when QPRICE is null or QPRICE=0 then PREVALUE else null end as uninvoiced_amount

from base




