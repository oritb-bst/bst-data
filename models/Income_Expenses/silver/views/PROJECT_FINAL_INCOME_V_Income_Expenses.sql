SELECT
    "Date",
    "מספר פרויקט",
    "מספר חוזה מזמין",
    "מס. לקוח",
    "סכום הכנסות",
    "סכום הכנסות" / 1000 AS "סכום הכנסות באלפי שח",
    "סכום מוגש - מחיר אחרי הנחה",
    "סכום תשלום צפוי",
    "סכום מאושר לתקבול", 
    "סטטוס",
    "מספר חשבון חלקי",
    "חברה",
    'MED_DOCUMENTS' as    "מקור הוצאה"

FROM {{ ref('MED_DOCUMENTS_D_V_Income_Expenses') }} 

WHERE "Date" >= TO_DATE('2026-06-01')


UNION ALL

SELECT
    "Date",
    "מספר פרויקט",
    NULL AS "מספר חוזה מזמין",
    NULL AS "מס. לקוח",
    SUM("זכות") AS "סכום הכנסות",
    SUM("זכות") / 1000 AS "סכום הכנסות באלפי שח",
    NULL AS "סכום מוגש - מחיר אחרי הנחה",
    NULL AS "סכום תשלום צפוי",
    NULL AS "סכום מאושר לתקבול", 
    NULL AS "סטטוס",
    NULL AS "מספר חשבון חלקי",
    "חברה",
    'ACCOUNT_TRANSACTIONS' as    "מקור הוצאה"

FROM {{ ref('ACCOUNT_TRANSACTIONS_V_Income_Expenses') }}

WHERE "Date" < TO_DATE('2026-06-01')

GROUP BY
    "חברה",
    "מספר פרויקט",
     "Date"

