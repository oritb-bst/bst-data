select
    DOCNO,
    DOC,
    PROJDES,
    PROJMANG,
    PROJTYPECODE,
    PROJTYPEDES,
    SOURCE_DB
from {{ ref('DIM_PROJECTS_STG') }}
