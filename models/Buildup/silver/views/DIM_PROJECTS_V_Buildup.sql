--DOCUMENTS_p
select
    DOCNO as "מספר פרויקט",
    DOC   as "פרויקט_ID",
    PROJDES as "שם פרויקט",
    PROJMANG as "שם מנהל פרויקט",
    PROJTYPECODE as "קוד סוג פרויקט",
    PROJTYPEDES as "תאור סוג פרויקט",
    BSA_SIZESUM as "סך הכל מטר רבוע לפרויקט",
    BSA_APARTSUM as "מספר יחידות דיור",
    STATDES      as "סטטוס פרויקט",
    SOURCE_DB  as "חברה"
from {{ ref('DIM_PROJECTS') }} d
where coalesce(projtypedes, '') not in (
        'ניהול',
        'לא פרוייקטאלי',
        'בדק ואחריות'
    )
and STATDES in ('בביצוע', 'הסתיים')
and SOURCE_DB = 'BLDUP'

  -- החרגת פרויקטים מהאקסל
  and not exists (
      select 1
      from {{ source('csv', 'EXCLUDED_PROJECTS_BLDUP') }} e
      where trim(to_varchar(e.docno)) = trim(to_varchar(d.docno))
  )