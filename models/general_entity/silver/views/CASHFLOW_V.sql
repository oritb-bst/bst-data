SELECT
    -- מזהים ונתוני פרויקט
    b.PROJECT_DOCNO                          AS "מספר פרויקט",
    b.INVOICE_NAME                           AS "חשבונית",
    b.RECEIPT_NAME                           AS "קבלה",
    b.INVOICE_DATE                           AS "תאריך חשבונית",
    b.BALDATE                                AS "ת. למאזן",
    b.TOTPRICE                               AS "סה""כ קבלה",
    b.TOTPRICEIV                             AS "סכום החשבונית",
    b.TOTKEREN                               AS "סכום הקרן",
    b.PEREXTRACTION                          AS "מע""מ",
    b.RINCIPALVATCODE                        AS "קוד אופן תשלום",
    b.RINCIPALVATDES                         AS "תיאור אופן תשלום",
    b.SOURCE_DB                              AS "חברה"

FROM {{ ref('CASHFLOW_STG') }} b -- שם מודל ה-Staging המכיל את שאילתת הבסיס שלך
