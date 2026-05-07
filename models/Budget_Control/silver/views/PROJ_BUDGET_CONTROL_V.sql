select 
    "PERIOD"   as "תקופה לבקרה",
    PROJECT_ID as "פרויקט",
    "MONTH"    as "חודש בקרה",
    DATE       as "תאריך בקרה",
    CURVERSION as "מהדורה נוכחית",
    SOURCE_DB  as "חברה"
from {{ ref('PROJ_BUDGET_CONTROL') }}