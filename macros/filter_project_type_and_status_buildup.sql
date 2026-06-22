-- מצרף לכל מודל רק את אוכלוסיית הפרויקטים התקפה של BLDUP:
-- סטטוסים בביצוע/הסתיים, ללא סוגי פרויקט מוחרגים,
-- לפי מספר פרויקט וחברה.

{% macro join_valid_projects_buildup(project_column, source_column, join_type='inner') %}

{{ join_type }} join (

    select distinct
        d.docno,
        d.source_db
    from {{ ref('DIM_PROJECTS') }} d

    left join {{ source('csv', 'excluded_projects_bldup') }} e --אקסל עם מספרי פרויקט לא להצגה
        on to_varchar(d.docno) = to_varchar(e.docno)

    where coalesce(projtypedes, '') not in (
        'ניהול',
        'לא פרוייקטאלי',
        'בדק ואחריות'
    )
      and d.statdes in ('בביצוע', 'הסתיים')
      and d.source_db = 'BLDUP'

      -- החרגת פרויקטים מהאקסל
      and e.docno is null

) p
    on {{ project_column }} = p.docno
   and {{ source_column }} = p.source_db

{% endmacro %}