SELECT
    item.value:DOCNO::string                AS DOCNO,
    item.value:IVNUMA::string               AS IVNUMA,
    item.value:BALDATE::date                AS BALDATE,
    item.value:TIVNUM::string               AS TIVNUM,
    item.value:TOTPRICE::float              AS TOTPRICE,
    item.value:RINCIPALVATCODE::string      AS RINCIPALVATCODE,
    item.value:RINCIPALVATDES::string       AS RINCIPALVATDES,
    item.value:PEREXTRACTION::float         AS PEREXTRACTION,
    item.value:TOTPRICEIV::float            AS TOTPRICEIV,
    item.value:TOTKEREN::float              AS TOTKEREN,
    item.value:IVDATE::date                 AS IVDATE,
    SOURCE_DB::string                       AS SOURCE_DB

FROM {{ source('json', 'ZCBS_PAYMENTRECEIPT') }},
LATERAL FLATTEN(input => DATA) item