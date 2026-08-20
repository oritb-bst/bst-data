--DOCUMENTS_P
select
    PROJECT_NAME as "מספר פרויקט",
    SUP_NAME     as "מספר ספק",
    CURDATE      as "Date",
    PRICE_AFTER_DIS_GR as "מחיר קבלת סחורה מספק אחרי הנחה",
    STATUS_GR          as "סטטוס קבלת סחורה מספק",
    DOCUMENT_NAME      as "מספר תעודה",
    t.SOURCE_DB        as "חברה"
from {{ ref('GOODS_RECEIPTS_STG') }} t

{{ join_bst_projects_budget_control('PROJECT_NAME', 't.SOURCE_DB') }}