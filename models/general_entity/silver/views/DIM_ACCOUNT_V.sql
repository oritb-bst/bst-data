

SELECT
    t.account_id                                         AS "חשבון_ID",
    a.account_number                                     AS "חשבון",
    a.account_des                                        AS "תאור חשבון",
    a.account_type_name                                  AS "כותרת מאזן/רווח והפ.",
    a.project_docno                                      AS "מספר פרויקט",
    a.project_id                                         AS "סוג חשבון" ,
    a.flag_acc_type,
FROM {{ ref('DIM_ACCOUNTS_STG') }} t

{{ join_valid_projects_BST_BUILDUP('a.project_docno', 'a.source_db') }}


