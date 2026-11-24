

SELECT
    a.account_id                                         AS "חשבון_ID",
    a.account_number                                     AS "חשבון",
    a.account_des                                        AS "תאור חשבון",
    a.account_type_name                                  AS "כותרת מאזן/רווח והפ.",
    a.project_docno                                      AS "מספר פרויקט", --קיים רק בחשבונות ראשיים
    a.project_id                                         AS "פרויקט_ID",  --קיים רק בחשבונות ראשיים                           
    a.flag_acc_type                                      AS "סוג חשבון",
FROM {{ ref('DIM_ACCOUNTS_STG') }} a

{{ join_valid_projects_BST_BUILDUP('a.project_docno', 'a.source_db') }}


