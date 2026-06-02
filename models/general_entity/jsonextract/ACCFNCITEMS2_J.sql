SELECT
    item.value:ACCOUNT::number(18,0)  AS ACCOUNT,
    item.value:BALDATE::DATE          AS BALDATE,
    item.value:DETAILS::string        AS DETAILS,
    item.value:DEBIT::float           AS DEBIT,
    item.value:CREDIT::float          AS CREDIT,
    SOURCE_DB::STRING                 AS SOURCE_DB

FROM {{ source('json', 'ACCFNCITEMS2') }},
LATERAL FLATTEN(input => DATA) item

