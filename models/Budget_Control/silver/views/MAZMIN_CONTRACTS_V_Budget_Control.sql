--MED_ORDERS_J
select
    PROJECT_NAME as "מספר פרויקט",
    PROJECT_ID   as "פרויקט_ID",
    ORD_NAME     as "מספר חוזה מזמין",
    CUST_NAME    as "מספר לקוח",
    PAY_DES      as "תנאי תשלום",
    MED_TYPE     as "סוג חוזה מזמין",
    TOTAL_PRICE  as "מחיר כולל מעמ",
    TOTAL_PRICE_K  as "מחיר כולל מעמ באלפי שח",
    CURDATE        as "תאריך חוזה מזמין",
    ORD_STATUS_DES as "סטטוס חוזה מזמין",
    CURRENCY       as "מטבע",
    CURRENCY_DES   as "סוג הצמדה",
    to_char(ESCALATION_START_DATE, 'MM/YY') as "חודש בסיס",
    BASE_RATE      as "מדד בסיס",
    t.SOURCE_DB    as "חברה"
from {{ ref('MAZMIN_CONTRACTS_STG') }} t

{{ join_bst_projects_budget_control('PROJECT_NAME', 't.SOURCE_DB') }}

where MED_TYPE = 'CO' 
and coalesce(TOTAL_PRICE, 0) > 0 