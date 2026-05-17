select
    DOCNO,
    DOC,
    PROJDES,
    PROJMANG,
    PROJTYPECODE,
    PROJTYPEDES,
    BSA_SIZESUM,
    BSA_APARTSUM,
    SOURCE_DB
from {{ ref('DIM_PROJECTS_STG') }}
