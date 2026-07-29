--BUD_CONTROLPERIODS_Z
select 
    BUD_CONTROL_PERIOD_ID as "בקרה תקציבית_ID",
    PROJECT_ID            as "פרויקט_ID",
    PROJECT_NAME          as "מספר פרויקט",
    BUD_CONTROL_MONTH     as "חודש בקרה",
    BUD_CONTROL_DATE      as "Date",
    CURVERSION            as "מהדורה נוכחית",
    IS_CLOSED             as "דגל תקציב סגור",
    IS_LATEST_CLOSED_BUDGET as "דגל חודש תקציב אחרון סגור",
    t.SOURCE_DB           as "חברה"
from {{ ref('PROJ_BUDGET_CONTROL_STG') }} t

{{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}