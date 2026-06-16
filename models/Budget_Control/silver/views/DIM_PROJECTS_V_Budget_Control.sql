--DOCUMENTS_p
select
    DOCNO as "מספר פרויקט",
    DOC   as "פרויקט_ID",
    PROJDES as "שם פרויקט",
    PROJMANG as "שם מנהל פרויקט",
    PROJTYPECODE as "קוד סוג פרויקט",
    PROJTYPEDES as "תאור סוג פרויקט",
    BSA_SIZESUM as "סך הכל מטר רבוע לפרויקט",
    BSA_APARTSUM as "מספר יחידות דיור",
    STATDES      as "סטטוס פרויקט",
    SOURCE_DB  as "חברה"
from {{ ref('DIM_PROJECTS') }}
where DOC in ('510197','528815','539220','579697','589607')
and SOURCE_DB = 'BST'