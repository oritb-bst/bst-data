--DOCUMENTS_p
select
    DOCNO    as "מספר פרויקט",
    DOC      as "פרויקט_ID",
    PROJDES  as "שם פרויקט",
    PROJMANG as "שם מנהל פרויקט",
    PROJTYPECODE as "קוד סוג פרויקט",
    PROJTYPEDES  as "תאור סוג פרויקט",
    BSA_SIZESUM  as "סך הכל מטר רבוע לפרויקט",
    BSA_APARTSUM as "מספר יחידות דיור",
    STATDES      as "סטטוס פרויקט",
    BUD_STARTORDERDATE as "תאריך צו תחילת עבודה",
    BUD_ASTARTDATE     as "תאריך התחלה בפועל",
    BUD_CONTDURATION   as "משך בחודשים חוזי",
    BUD_CONTENDDATE    as "תאריך סיום ביצוע חוזי",
    SOURCE_DB  as "חברה"
from {{ ref('DIM_PROJECTS_STG') }}
where DOC in ('510197','528815','539220','579697','589607')
and SOURCE_DB = 'BST'