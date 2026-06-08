--MED_PORDERITEMS_SUBFORM
SELECT
    sub.value:MED_SECTION::varchar  as MED_SECTION,
    sub.value:MED_SECDES::varchar   as MED_SECDES,
    sub.value:TQUANT::float        as TQUANT,
    sub.value:PRICE::float         as PRICE,
    sub.value:QPRICE::float        as QPRICE,
    sub.value:ORD::varchar         as ORD,
    SOURCE_DB::string               as SOURCE_DB

FROM {{ source('json', 'MED_PORDERITEMS_SUBFORM') }},
LATERAL FLATTEN(input => DATA) item,
LATERAL FLATTEN(INPUT => item.value:MED_PORDERITEMS_SUBFORM) sub