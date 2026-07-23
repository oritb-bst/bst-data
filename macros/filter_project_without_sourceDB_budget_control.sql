-- מקרו שמצרף רק את חמשת הפרויקטים הרלוונטיים של מירי
-- לפי מספר פרויקט

{% macro join_bst_projects_without_sourceDB_budget_control(project_column, join_type='inner') %}

{{ join_type }} join (

    select distinct
        docno
    from {{ ref('DIM_PROJECTS') }}
    where docno in (
          PR25000009,
          PR25000012,
          PR26000004,
          PR26000006,
          PR25000004
      )

) p
    on {{ project_column }} = p.doc

{% endmacro %}