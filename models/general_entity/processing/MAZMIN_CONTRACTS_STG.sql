--MED_ORDERS_J
select
    DOCNO      as PROJECT_NAME,
    PROJ       as PROJECT_ID,
    CUSTNAME   as CUST_NAME,
    PAYDES     as PAY_DES,
    MED_TYPE   as MED_TYPE,
    TOTPRICE   as TOTAL_PRICE,
    TOTPRICE / 1000 as TOTAL_PRICE_K,
    CURDATE,
    ORDSTATUSDES as ORD_STATUS_DES,
    mo.ORDNAME   as ORD_NAME,
    mc.CURRENCY,
    mc.CURRENCY_DES,
    mc.ESCALATION_START_DATE,
    mc.BASE_RATE,
    mo.SOURCE_DB
from {{ ref('MED_ORDERS_J') }} mo

left join {{ ref('MAZMIN_CONTRACT_ESCALATION_STG') }} mc
    on mo.DOCNO = mc.PROJECT_NAME
   and mo.ORDNAME = mc.ORD_NAME
   and mo.SOURCE_DB = mc.SOURCE_DB