select
    DOCNO  as "מספר פרויקט",
    DOC as id,
    PROJDES as "שם פרויקט",
    PROJMANG as "שם מנהל פרויקט",
    PROJTYPECODE as "קוד סוג פרויקט",
    PROJTYPEDES as "תאור סוג פרויקט"
from {{ ref('DIM_PROJECTS_STG') }}
