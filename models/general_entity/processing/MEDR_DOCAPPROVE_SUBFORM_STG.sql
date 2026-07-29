--מסך בן MEDR_DOCAPPROVE - סכום מאושר לתקבול 
-- + מסך אב MED_DOCUMENTS_D

SELECT
    SUM(QPRICE) OVER (
        PARTITION BY DOCNO, MED_EXEMONTH
    ) AS TOTAL_QPRICE,

    DOC,
    QPRICE,
    TRY_TO_DATE('01/' || MED_EXEMONTH, 'DD/MM/YY') AS execution_date,
    DOCNO as PROJECT_DOCNO,
    SOURCE_DB

FROM {{ ref('MEDR_DOCAPPROVE_SUBFORM_J') }}



