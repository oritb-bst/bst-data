-- מצרף לכל מודל רק את אוכלוסיית הפרויקטים התקפה של BLDUP:
-- סטטוסים בביצוע/הסתיים, ללא סוגי פרויקט מוחרגים,
-- לפי מספר פרויקט וחברה.

{% macro join_valid_projects_buildup(project_column, source_column, join_type='inner') %}

{{ join_type }} join (

    select distinct
        docno,
        source_db
    from {{ ref('DIM_PROJECTS') }}
    where coalesce(projtypedes, '') not in (
        'ניהול',
        'לא פרוייקטאלי',
        'בדק ואחריות'
    )
      and statdes in ('בביצוע', 'הסתיים')
      and source_db = 'BLDUP'

) p
    on {{ project_column }} = p.docno
   and {{ source_column }} = p.source_db

{% endmacro %}