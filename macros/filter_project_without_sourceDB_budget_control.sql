-- מקרו שמצרף רק את חמשת הפרויקטים הרלוונטיים של מירי
-- לפי מספר פרויקט

{% macro join_bst_projects_without_sourceDB_budget_control(project_column, join_type='inner') %}

{{ join_type }} join (

    select distinct
        docno
    from {{ ref('DIM_PROJECTS_STG') }}
    where docno in (
          'PR25000009',
          'PR25000012',
          'PR26000004',
          'PR26000006',
          'PR25000004',
          'PR22000005',
          'PR25000002',
          'PR26000002',
          'PR25000010'--,
--          'PR22000012'
      )

) p
    on {{ project_column }} = p.docno

{% endmacro %}