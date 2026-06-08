{% macro join_valid_projects(project_column, join_type='inner') %}

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

) p
    on {{ project_column }} = p.docno

{% endmacro %}