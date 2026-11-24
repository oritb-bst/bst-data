

SELECT
    account_id                                         AS "חשבון_ID",
    account_number                                     AS "חשבון",
    account_des                                        AS "תאור חשבון",
    account_type_name                                  AS "כותרת מאזן/רווח והפ.",
    project_docno                                      AS "מספר פרויקט", --קיים רק בחשבונות ראשיים
    project_id                                         AS "פרויקט_ID",  --קיים רק בחשבונות ראשיים                           
    flag_acc_type                                      AS "סוג חשבון",
    source_db                                          AS "חברה"
FROM {{ ref('DIM_ACCOUNTS_STG') }} 

