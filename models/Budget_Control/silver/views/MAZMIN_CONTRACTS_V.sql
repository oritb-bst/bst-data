--MED_ORDERS_J
select
    PROJECT_NAME as "מספר פרויקט",
    PROJECT_ID   as "פרויקט_ID",
    CUST_NAME    as "מספר לקוח",
    MED_PAY_DES  as "תנאי תשלום",
    MED_TYPE     as "סוג חוזה מזמין",
    TOTAL_PRICE  as "מחיר כולל מעמ",
    CURDATE      as "Date",
    ORD_STATUS_DES as "סטטוס חוזה מזמין",
    SOURCE_DB as "חברה"
from {{ ref('MAZMIN_CONTRACTS_STG') }}