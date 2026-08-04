--מסך בן MEDR_DOCAPPROVE - סכום מאושר לתקבול 
-- + מסך אב MED_DOCUMENTS_D

SELECT
    SUM(QPRICE) OVER (
        PARTITION BY DOC
    ) AS TOTAL_QPRICE,

    DOC,
    QPRICE,
    SOURCE_DB

FROM {{ ref('MEDR_DOCAPPROVE_SUBFORM_J') }}



