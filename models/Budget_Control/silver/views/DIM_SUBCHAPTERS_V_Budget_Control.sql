-- COSTCENTERS3Q

with subchapters as (
    select
        *,
        try_to_number(regexp_substr(trim(SUB_CHAPTER_NAME), '^[0-9]+')) as subchapter_num
    from {{ ref('DIM_SUBCHAPTERS') }}
    where SOURCE_DB = 'BST'
)

select
    coalesce(SUB_CHAPTER_NAME, 'ללא') as "מספר תת פרק",
    case when SUB_CHAPTER_NAME is null then 'ללא תת פרק' else SUB_CHAPTER_DES end as "תיאור תת פרק",

    case when subchapter_num = 81 then 'תיקוני בדק ואחריות'
         when subchapter_num = 82 then 'בצ"מ'
         when subchapter_num between 90 and 95 then 'כלליות'
         when subchapter_num = 96 then 'אגף ביצוע'
         when subchapter_num between 1 and 95 or subchapter_num in (99, 991, 992, 993) then 'ישירות' else 'לא מסווג'
    end as "מקור",

    SUB_CHAPTER_NAME_FOR_BUD_CONTROL as "מספר תת פרק - בקרה תקציבית",
    SUB_CHAPTER_DES_FOR_BUD_CONTROL  as "תיאור תת פרק - בקרה תקציבית",
    SOURCE_DB                        as "חברה"

from subchapters

union all

select
    'ללא' as "מספר תת פרק",
    'ללא תת פרק' as "תיאור תת פרק",
    'ללא' as "SUBCHAPTER_src",
    null as "מספר תת פרק - בקרה תקציבית",
    null as "תיאור תת פרק - בקרה תקציבית",
    'BST' as "חברה"