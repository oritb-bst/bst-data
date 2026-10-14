{% macro join_valid_projects(project_column, source_column, join_type='inner') %}

{{ join_type }} join (

    -- 1. אוכלוסיית הפרויקטים לחברת BST
    select distinct
        d.docno,
        d.source_db
    from {{ ref('DIM_PROJECTS_STG') }} d
    left join {{ source('csv', 'EXCLUDED_PROJECTS_BST') }} e 
        on to_varchar(d.docno) = to_varchar(e.docno)
    where coalesce(projtypedes, '') not in (
        'ניהול',
        'לא פרוייקטאלי',
        'בדק ואחריות'
    )
    and trim(d.docno) like 'PR%'
    and d.source_db != 'BLDUP'
    and e.docno is null

    UNION

    -- 2. אוכלוסיית הפרויקטים לחברת BLDUP
    select distinct
        d.docno,
        d.source_db
    from {{ ref('DIM_PROJECTS_STG') }} d
    left join {{ source('csv', 'EXCLUDED_PROJECTS_BLDUP') }} e 
        on to_varchar(d.docno) = to_varchar(e.docno)
    where coalesce(projtypedes, '') not in (
        'ניהול',
        'לא פרוייקטאלי',
        'בדק ואחריות'
    )
    and d.statdes in ('בביצוע', 'הסתיים')
    and d.source_db = 'BLDUP'
    and e.docno is null

) p
    on {{ project_column }} = p.docno
   and {{ source_column }} = p.source_db

{% endmacro %}