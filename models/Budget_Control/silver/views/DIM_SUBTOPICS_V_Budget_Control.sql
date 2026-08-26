-- COSTCENTERS4Q משאבים
select
    SUB_CHAPTER_NAME as "מספר משאב",
    SUB_CHAPTER_NAME as "תיאור משאב",
    SOURCE_DB        as "חברה"
from {{ ref('DIM_SUBTOPICS_STG') }} 