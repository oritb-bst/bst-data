--BUD_CONTROLPERIODS_Z
select 
    BUD_CONTROL_PERIOD_ID as "בקרה תקציבית_ID",
    PROJECT_ID            as "פרויקט_ID",
    PROJECT_NAME          as "מספר פרויקט",
    BUD_CONTROL_MONTH     as "חודש בקרה",
    BUD_CONTROL_DATE      as "Date",
    CURVERSION            as "מהדורה נוכחית",
    t.SOURCE_DB             as "חברה"
from {{ ref('PROJ_BUDGET_CONTROL') }} t

{{ join_bst_projects_budget_control('t.PROJECT_ID', 't.SOURCE_DB') }}