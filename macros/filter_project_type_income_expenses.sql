-- מצרף לכל מודל רק את אוכלוסיית הפרויקטים התקפה של 
--  ללא סוגי פרויקט מוחרגים
--רק מה שמתחיל בPR
--סינון על BST מתבצע כאן

{% macro join_valid_projects(project_column, source_db_column=None, join_type='inner') %}

{{ join_type }} join (

    select distinct
        docno,
        source_db,
        projtypedes
    from {{ ref('DIM_PROJECTS') }}
    where coalesce(projtypedes, '') not in (
        'ניהול',
        'לא פרוייקטאלי',
        'בדק ואחריות'
    )
      and trim(docno) like 'PR%'
      and source_db = 'BST'
      and docno not in (
        'PR23000005',
        'PR25000011',
        'PR23000002',
        'PR24000012',
        'PR21000019'
      )

) p
    on {{ project_column }} = p.docno

{% if source_db_column %}
   and {{ source_db_column }} = p.source_db
{% endif %}

{% endmacro %}