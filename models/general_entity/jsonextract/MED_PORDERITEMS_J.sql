--MED_PORDERITEMS_SUBFORM
SELECT
    sub.value:MED_SECTION::varchar  as MED_SECTION,
    sub.value:MED_SECDES::varchar   as MED_SECDES,
    sub.value:TQUANT::float         as TQUANT,
    sub.value:PRICE::float          as PRICE,
    sub.value:QPRICE::float         as QPRICE,
    sub.value:ORD::varchar          as ORD,
    sub.value:MED_QPRICE_TO::float  as MED_QPRICE_TO,
    sub.value:BUD_SUBTOPICNAME::string  as BUD_SUBTOPICNAME,
    sub.value:BUD_SUBTOPICDES::string   as BUD_SUBTOPICDES,
    SOURCE_DB::string                   as SOURCE_DB

FROM {{ source('json', 'MED_PORDERITEMS_SUBFORM') }},
LATERAL FLATTEN(input => DATA) item,
LATERAL FLATTEN(INPUT => item.value:MED_PORDERITEMS_SUBFORM) sub