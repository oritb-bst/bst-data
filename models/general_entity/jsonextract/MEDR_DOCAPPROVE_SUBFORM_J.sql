--מסך בן MEDR_DOCAPPROVE - סכום מאושר לתקבול 

SELECT
    sub.value:QPRICE ::FLOAT              AS QPRICE,
    item.value:DOC::number                AS DOC,
    item.value:MED_EXEMONTH::string       AS MED_EXEMONTH,
    item.value:DOCNO::string              AS DOCNO,
    SOURCE_DB::STRING                     AS SOURCE_DB

FROM {{ source('json', 'MEDR_DOCAPPROVE_SUBFORM') }},
LATERAL FLATTEN(input => DATA) item,
LATERAL FLATTEN(input => item.value:MEDR_DOCAPPROVE_SUBFORM) sub




