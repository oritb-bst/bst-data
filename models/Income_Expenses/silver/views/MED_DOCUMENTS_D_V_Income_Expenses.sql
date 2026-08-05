WITH qprice AS (

    SELECT
        DOC,
        SOURCE_DB,
        SUM(QPRICE) AS QPRICE

    FROM {{ ref('MEDR_DOCAPPROVE_SUBFORM_STG') }}

    GROUP BY
        DOC,
        SOURCE_DB

),

base AS (

    SELECT
        a.EXECUTION_DATE,
        a.PROJECT_DOCNO,
        a.ORDNAME,
        a.CUSTNAME,
        a.STATDES,
        a.BOOKNUM,
        a.DOC,
        a.SOURCE_DB,

        SUM(a.DISPRICE) AS DISPRICE,
        SUM(a.EXPECTPAY) AS EXPECTPAY,
        SUM(q.QPRICE) AS QPRICE

    FROM {{ ref('MED_DOCUMENTS_D_STG') }} a

    LEFT JOIN qprice q
        ON a.DOC = q.DOC
       AND a.SOURCE_DB = q.SOURCE_DB

     {{ join_valid_projects('a.PROJECT_DOCNO', 'a.SOURCE_DB') }} 


    GROUP BY
        a.EXECUTION_DATE,
        a.PROJECT_DOCNO,
        a.ORDNAME,
        a.CUSTNAME,
        a.STATDES,
        a.BOOKNUM,
        a.DOC,
        a.SOURCE_DB

)



SELECT
    EXECUTION_DATE AS "Date",
    PROJECT_DOCNO AS "מספר פרויקט",
    ORDNAME AS "מספר חוזה מזמין",
    CUSTNAME AS "מס. לקוח",

    CASE
        WHEN QPRICE IS NOT NULL THEN QPRICE
        WHEN DISPRICE IS NOT NULL THEN DISPRICE
        ELSE EXPECTPAY
    END AS "סכום הכנסות",

     DISPRICE AS "סכום מוגש - מחיר אחרי הנחה",
     EXPECTPAY AS "סכום תשלום צפוי",
     QPRICE AS "סכום מאושר לתקבול", 

    STATDES AS "סטטוס",
    BOOKNUM AS "מספר חשבון חלקי",
    DOC,
    SOURCE_DB AS "חברה"

FROM base



