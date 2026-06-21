--COSTCENTERS3Q
select
    coalesce(SUB_CHAPTER_NAME, 'ללא')       as "מספר תת פרק",
    coalesce(SUB_CHAPTER_DES, 'ללא תת פרק') as "תיאור תת פרק",
    SUB_CHAPTER_NAME_FOR_BUD_CONTROL as "מספר תת פרק - בקרה תקציבית",
    SUB_CHAPTER_DES_FOR_BUD_CONTROL  as "תיאור תת פרק - בקרה תקציבית",
	SOURCE_DB                        as "חברה"
from {{ ref('DIM_SUBCHAPTERS') }}
where SOURCE_DB='BST'