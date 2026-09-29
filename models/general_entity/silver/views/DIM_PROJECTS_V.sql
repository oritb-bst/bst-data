select
    d.DOCNO              as "מספר פרויקט",
    d.DOC                as "פרויקט_ID",
    d.PROJDES            as "שם פרויקט",
    d.PROJMANG           as "שם מנהל פרויקט",
    d.PROJTYPECODE       as "קוד סוג פרויקט",
    d.PROJTYPEDES        as "תאור סוג פרויקט",
    d.BSA_SIZESUM        as "סך הכל מטר רבוע לפרויקט",
    d.BSA_APARTSUM       as "מספר יחידות דיור",
    d.STATDES            as "סטטוס פרויקט",
    d.BUD_STARTORDERDATE as "תאריך צו תחילת עבודה",
    d.SOURCE_DB          as "חברה"
from {{ ref('DIM_PROJECTS_STG') }} d

{{ join_valid_projects('d.DOCNO', 'd.SOURCE_DB') }}