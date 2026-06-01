--COSTCENTERS3Q
select
    SUB_CHAPTER_NAME as "מספר תת פרק",
	SUB_CHAPTER_DES  as "תיאור תת פרק",
	SOURCE_DB        as "חברה"
from {{ ref('DIM_SUBCHAPTERS') }}