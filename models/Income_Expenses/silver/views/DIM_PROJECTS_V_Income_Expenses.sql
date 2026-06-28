--DOCUMENTS_p
select
    a.DOCNO as "מספר פרויקט",
    DOC   as "פרויקט_ID",
    PROJDES as "שם פרויקט",
    PROJMANG as "שם מנהל פרויקט",
    PROJTYPECODE as "קוד סוג פרויקט",
    a.PROJTYPEDES as "תאור סוג פרויקט",
    BSA_SIZESUM as "סך הכל מטר רבוע לפרויקט",
    BSA_APARTSUM as "מספר יחידות דיור",
    STATDES      as "סטטוס פרויקט",
    a.SOURCE_DB  as "חברה"
from {{ ref('DIM_PROJECTS') }} a

{{ join_valid_projects('a.DOCNO', 'a.SOURCE_DB') }}
