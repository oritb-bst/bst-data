--DOCUMENTS_P
select
    a.PROJECT_NAME as "מספר פרויקט",
    SUP_NAME     as "מספר ספק",
    CURDATE      as "Date",
    PRICE_AFTER_DIS_GR as "מחיר קבלת סחורה מספק אחרי הנחה",
    STATUS_GR          as "סטטוס קבלת סחורה מספק",
    DOCUMENT_NAME      as "מספר תעודה",
    a.SOURCE_DB          as "חברה"
from {{ ref('GOODS_RECEIPTS_STG') }} a

{{ join_valid_projects_project_managment('a.PROJECT_NAME', 'a.source_db') }}