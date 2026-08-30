-- COSTCENTERS4Q משאבים
select
    SUB_TOPIC_NAME as "מספר משאב",
    SUB_TOPIC_DES  as "תיאור משאב",
    SOURCE_DB      as "חברה"
from {{ ref('DIM_SUBTOPICS_STG') }} 