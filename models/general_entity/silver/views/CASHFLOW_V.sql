SELECT
    -- מזהים ונתוני פרויקט
    b.PROJECT_DOCNO                          AS "מספר פרויקט",
    b.INVOICE_NAME                           AS "חשבונית",
    b.RECEIPT_NAME                           AS "קבלה",
    b.INVOICE_DATE                           AS "Date", --תאריך התקבול
    b.BALDATE                                AS "ת. למאזן",
    b.TOTPRICE                               AS "סה""כ קבלה",
    b.TOTPRICE  /1000                        AS "סה""כ קבלה באלפי שח",
    b.TOTPRICEIV                             AS "סכום החשבונית",
    b.TOTPRICEIV /1000                       AS "סכום החשבונית באלפי שח",
    b.TOTKEREN                               AS "סכום הקרן",
    b.TOTKEREN /1000                         AS "סכום הקרן באלפי שח",
    b.PEREXTRACTION                          AS "מע""מ",
    b.PEREXTRACTION /1000                    AS "מע""מ באלפי שח",
    b.RINCIPALVATCODE                        AS "קוד אופן תשלום",
    b.RINCIPALVATDES                         AS "תיאור אופן תשלום",
    b.SOURCE_DB                              AS "חברה"

FROM {{ ref('CASHFLOW_STG') }} b -- שם מודל ה-Staging המכיל את שאילתת הבסיס שלך
