SELECT
    -- מזהים ונתוני פרויקט
    b.PROJECT_NAME                           AS "מספר פרויקט",
    b.INVOICE_NUM                            AS "חשבונית",
    b.RECEIPT_NUM                            AS "תקבול/תשלום",
   -- b.INVOICE_DATE                           AS "ת. תקבול", 
    b.BALDATE                                AS "Date", -- תאריך למאזן
    b.FNCDATE                                AS "תאריך ערך",
    b.TOTPRICE                               AS "סכום התקבול/תשלום",
    b.TOTPRICE  /1000                        AS "סכום התקבול/תשלום באלפי שח",
    b.TOTKEREN                               AS "סכום הקרן",
    b.TOTKEREN /1000                         AS "סכום הקרן באלפי שח",
    b.PEREXTRACTION                          AS "אחוז המע""מ",
    b.TOTMAAM                                AS "סכום המע""מ",
    b.TOTMAAM /1000                          AS "סכום המע""מ באלפי שח",
    b.TOTPRICE_TAZRIM /1000                  AS "תזרים באלפי שח",
    b.TOTKEREN_TAZRIM /1000                  AS "תזרים - קרן באלפי שח",
    b.TOTMAAM_TAZRIM /1000                   AS "תזרים - מעמ באלפי שח",
    b.CLASSIFICATION                         AS "סיווג",
    b.RINCIPALVATCODE                        AS "קוד אופן תשלום",
    b.RINCIPALVATDES                         AS "תיאור אופן תשלום",
    b.ACCNAME                                AS "מספר חשבון",
    b.ACCDES                                 AS "תאור חשבון",
    b.CURDATE                                AS "ת. אסמכתא",
    b.SOURCE_DB                              AS "חברה"
FROM {{ ref('CASHFLOW_STG') }} b 