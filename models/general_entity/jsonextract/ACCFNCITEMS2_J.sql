SELECT
    item.value:ACCOUNT::NUMBER(18, 0) AS account,
    sub.value:BALDATE::DATE AS baldate,
    sub.value:DETAILS::STRING AS details,
    sub.value:DEBIT::FLOAT AS debit,
    sub.value:CREDIT::FLOAT AS credit,
    source_db::STRING AS source_db,

FROM {{ source('json', 'ACCFNCITEMS2_SUBFORM') }},
        LATERAL FLATTEN(input => data) AS item,
        LATERAL FLATTEN(input => item.value:ACCFNCITEMS2_SUBFORM) AS sub
