--MED_ORDERS_J
select
    PROJECT_NAME as "מספר פרויקט",
    PROJECT_ID   as "פרויקט_ID",
    CUST_NAME    as "מספר לקוח",
    PAY_DES      as "תנאי תשלום",
    MED_TYPE     as "סוג חוזה מזמין",
    TOTAL_PRICE  as "מחיר כולל מעמ",
    TOTAL_PRICE_K as "מחיר כולל מעמ באלפי שח",
    CURDATE       as "Date",
    ORD_STATUS_DES as "סטטוס חוזה מזמין",
    t.SOURCE_DB as "חברה"
from {{ ref('MAZMIN_CONTRACTS_STG') }} t

{{ join_bst_projects_budget_control('PROJECT_NAME', 't.SOURCE_DB') }}
