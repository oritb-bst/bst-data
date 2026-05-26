--DOCUMENTS_P
select
    PROJECT_NAME as "מספר פרויקט",
    SUP_NAME     as "מספר ספק",
    CURDATE      as "Date",
    PRICE_AFTER_DIS_GR as "מחיר קבלת סחורה מספק אחרי הנחה",
    STATUS_GR          as "סטטוס קבלת סחורה מספק",
    SOURCE_DB          as "חברה"
from {{ ref('GOODS_RECEIPTS') }}