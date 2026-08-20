-- מקרו שמצרף רק את חמשת הפרויקטים הרלוונטיים של מירי
-- BST לפי מספר פרויקט וחברה

{% macro join_bst_projects_budget_control(project_column, company_column, join_type='inner') %}

{{ join_type }} join (

    select distinct
        docno,
        source_db
    from {{ ref('DIM_PROJECTS_STG') }}
    where source_db = 'BST'
      and docno in (
          'PR25000009',
          'PR25000012',
          'PR26000004',
          'PR26000006',
          'PR25000004'
      )

) p
    on {{ project_column }} = p.docno
   and {{ company_column }} = p.source_db

{% endmacro %}