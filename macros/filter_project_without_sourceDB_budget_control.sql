-- מקרו שמצרף רק את חמשת הפרויקטים הרלוונטיים של מירי
-- BST לפי מספר פרויקט וחברה

{% macro join_bst_projects_without_sourceDB_budget_control(project_column, join_type='inner') %}

{{ join_type }} join (

    select distinct
        doc
    from {{ ref('DIM_PROJECTS') }}
    where doc in (
          510197,
          528815,
          539220,
          579697,
          589607
      )

) p
    on {{ project_column }} = p.doc

{% endmacro %}