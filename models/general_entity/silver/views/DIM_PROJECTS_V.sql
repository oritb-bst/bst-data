select
    DOCNO  as "מספר פרויקט",
    DOC as id,
    PROJDES as "שם פרויקט",
    PROJMANG as "שם מנהל פרויקט",
    PROJTYPECODE as "קוד סוג פרויקט",
    PROJTYPEDES as "תאור סוג פרויקט",
    SOURCE_DB  as "חברה"
from {{ ref('DIM_PROJECTS') }}
