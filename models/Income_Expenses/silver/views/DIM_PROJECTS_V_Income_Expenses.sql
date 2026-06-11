--DOCUMENTS_p
select
    t.DOCNO as "מספר פרויקט",
    DOC   as "פרויקט_ID",
    PROJDES as "שם פרויקט",
    PROJMANG as "שם מנהל פרויקט",
    PROJTYPECODE as "קוד סוג פרויקט",
    t.PROJTYPEDES as "תאור סוג פרויקט",
    BSA_SIZESUM as "סך הכל מטר רבוע לפרויקט",
    BSA_APARTSUM as "מספר יחידות דיור",
    t.SOURCE_DB  as "חברה"
from {{ ref('DIM_PROJECTS') }} t

{{ join_valid_projects('t.DOCNO') }}

