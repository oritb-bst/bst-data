-- מצרף לכל מודל רק את אוכלוסיית הפרויקטים התקפה של 
--  ללא סוגי פרויקט מוחרגים
--רק מה שמתחיל בPR
--סינון על BST מתבצע כאן

{% macro join_valid_projects(project_column, source_db_column=None, join_type='inner') %}

{{ join_type }} join (

    select distinct
        d.docno,
        source_db,
        projtypedes
    from {{ ref('DIM_PROJECTS') }} d

    left join {{ source('csv', 'EXCLUDED_PROJECTS_BST') }} e --אקסל עם מספרי פרויקט לא להצגה
        on to_varchar(d.docno) = to_varchar(e.docno)

    where coalesce(projtypedes, '') not in (
        'ניהול',
        'לא פרוייקטאלי',
        'בדק ואחריות'
    )
      and trim(d.docno) like 'PR%'
      and source_db = 'BST'
      -- החרגת פרויקטים מהאקסל
      and e.docno is null

) p
    on {{ project_column }} = p.docno

{% if source_db_column %}
   and {{ source_db_column }} = p.source_db
{% endif %}

{% endmacro %}