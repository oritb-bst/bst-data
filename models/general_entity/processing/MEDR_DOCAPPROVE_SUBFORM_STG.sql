--מסך בן MEDR_DOCAPPROVE - סכום מאושר לתקבול 


SELECT
    DOC,
    QPRICE,
    SOURCE_DB

FROM {{ ref('MEDR_DOCAPPROVE_SUBFORM_J') }}



