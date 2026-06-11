SELECT
    t.account_id                                         AS "חשבון (ID)",
    a.account_number                                     AS "חשבון",
    a.account_des                                        AS "תאור חשבון",
    a.account_type_name                                  AS "כותרת מאזן/רווח והפ.",
    a.project_docno                                      AS "פרויקט",
    a.project_id                                         AS "פרויקט (ID)",
    t.baldate                                            AS "ת. למאזן",
    t.account_details                                    AS "פרטים",
    t.account_debit                                      AS "חובה",
    t.account_credit                                     AS "זכות",
    t.execution_date                                     AS "תאריך ביצוע",
    t.missing_date_flag                                  AS "דגל תאריך חסר",
    t.source_db                                          AS "חברה"

FROM {{ ref('ACCFNCITEMS') }} t

INNER JOIN {{ ref('ACCOUNTS') }} a
    ON t.account_id = a.account_id
   AND t.source_db = a.source_db

{{ join_valid_projects('a.project_docno') }}

WHERE a.account_type_name = 'הכנסות'  AND  t.SOURCE_DB = 'BST'