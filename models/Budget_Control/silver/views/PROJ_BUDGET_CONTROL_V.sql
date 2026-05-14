select 
    BUD_CONTROL_PERIOD_ID as "תקופה לבקרה",
    PROJECT_ID            as "מספר פרויקט",
    PROJECT_NAME          as "שם פרויקט",
    BUD_CONTROL_MONTH     as "חודש בקרה",
    BUD_CONTROL_DATE      as "תאריך בקרה",
    CURVERSION            as "מהדורה נוכחית",
    SOURCE_DB             as "חברה"
from {{ ref('PROJ_BUDGET_CONTROL') }}