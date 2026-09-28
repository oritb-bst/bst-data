SELECT
    item.value:DOCNO::string                AS DOCNO,
    item.value:IVNUMA::string               AS IVNUMA,
    item.value:BALDATE::date                AS BALDATE,
    item.value:IVNUM::string                AS IVNUM,
    item.value:RINCIPALVATCODE::string      AS RINCIPALVATCODE,
    item.value:RINCIPALVATDES::string       AS RINCIPALVATDES,
    item.value:PEREXTRACTION::float         AS PEREXTRACTION,
    item.value:TOTPRICEIV::float            AS TOTPRICEIV,
    item.value:TOTKEREN::float              AS TOTKEREN,
    item.value:IVDATE::date                 AS IVDATE,
    item.value:CASHFLOWCLASSIFDES::string   AS CASHFLOWCLASSIFDES,
    item.value:ACCNAME::string              AS ACCNAME,
    item.value:ACCDES::string               AS ACCDES,
    item.value:TIVDATE::date                AS TIVDATE,
    item.value:FNCDATE::date                AS FNCDATE,
    item.value:PRICEINOUT::float            AS PRICEINOUT,
    item.value:TOTMAAM::float               AS TOTMAAM,
    SOURCE_DB::string                       AS SOURCE_DB

FROM {{ source('json', 'ZCBS_PAYMENTRECEIPT') }},
LATERAL FLATTEN(input => DATA) item