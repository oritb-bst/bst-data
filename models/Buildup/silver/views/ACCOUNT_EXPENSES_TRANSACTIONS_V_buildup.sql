--תנועות יומן הוצאות בלבד עבור בילדאפ - Orit

SELECT
    t.account_id                                         AS "חשבון_ID",
    a.account_number                                     AS "חשבון",
    a.account_des                                        AS "תאור חשבון",
    a.account_type_name                                  AS "כותרת מאזן/רווח והפ.",
    a.project_docno                                      AS "מספר פרויקט",
    a.project_id                                         AS "פרויקט_ID" ,
    t.baldate                                            AS  "Date", -- "ת. למאזן",
    t.fncdate                                            AS "תאריך ערך",
    t.account_details                                    AS "פרטים",
    t.account_debit                                      AS "חובה",
    t.account_credit                                     AS "זכות",
    t.source_db                                          AS "חברה",
    t.stornoflag                                         AS "stornoflag",
    t.fncnum                                             AS "מספר תנועה"
FROM {{ ref('ACCFNCITEMS_STG') }} t

INNER JOIN {{ ref('ACCOUNTS_STG') }} a
    ON t.account_id = a.account_id
   AND t.source_db = a.source_db

{{ join_valid_projects_buildup('a.project_docno', 't.SOURCE_DB') }}

WHERE {{ filter_last_n_years('t.baldate') }} --סינון שנים

AND a.account_type_name IN ('עלות המכירות') 
    and t.stornoflag IS DISTINCT FROM 'Y'