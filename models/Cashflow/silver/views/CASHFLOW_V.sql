SELECT
    -- מזהים ונתוני פרויקט
    b.PROJECT_NAME                          AS "מספר פרויקט",
    b.INVOICE_NUM                            AS "חשבונית",
    b.RECEIPT_NUM                            AS "תקבול/תשלום",
    b.INVOICE_DATE                           AS "Date", 
    b.BALDATE                                AS "ת. למאזן",
    b.TIVDATE                                AS "ת. תקבול/תשלום",
    b.FNCDATE                                AS "ת. ערך",
    b.PRICEINOUT                             AS "סכום התקבול/תשלום",
    b.PRICEINOUT  /1000                      AS "סכום התקבול/תשלום באלפי שח",
    b.TOTKEREN                               AS "סכום הקרן",
    b.TOTKEREN /1000                         AS "סכום הקרן באלפי שח",
    b.PEREXTRACTION                          AS "אחוז המע""מ",
    b.TOTMAAM                                AS "סכום המע""מ",
    b.TOTMAAM /1000                          AS "סכום המע""מ באלפי שח",
    b.CLASSIFICATION                         AS "סיווג",
    b.RINCIPALVATCODE                        AS "קוד אופן תשלום",
    b.RINCIPALVATDES                         AS "תיאור אופן תשלום",
    b.ACCNAME                                AS "מספר חשבון",
    b.ACCDES                                 AS "תאור חשבון",
    b.SOURCE_DB                              AS "חברה"
FROM {{ ref('CASHFLOW_STG') }} b 