--מודול מזמין

SELECT
    EXECUTION_DATE AS Date,
    PROJECT_DOCNO AS "מספר פרויקט",
    ORDNAME AS "מספר חוזה מזמין",
    CUSTNAME AS "מס. לקוח",
    DISPRICE AS "סכום מוגש - מחיר אחרי הנחה",
    MED_APPQPRICE AS "סכום מאושר שוטף",
    EXPECTPAY AS "סכום תשלום צפוי",
    STATDES AS "סטטוס",
    BOOKNUM AS "מספר חשבון חלקי",
    a.DOC,
    b.TOTAL_QPRICE,
    a.SOURCE_DB AS "חברה"

FROM {{ ref('MED_DOCUMENTS_D_STG') }} a

{{ join_valid_projects('a.PROJECT_DOCNO', 'a.SOURCE_DB') }}

LEFT JOIN {{ ref('MEDR_DOCAPPROVE_SUBFORM_STG') }} b
    ON a.DOC = b.DOC
    AND a.SOURCE_DB = b.SOURCE_DB