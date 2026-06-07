--MED_PORDERITEMS_SUBFORM
SELECT
    item.value:MED_SECTION::varchar  as MED_SECTION,
    item.value:MED_SECDES::varchar   as MED_SECDES,
    item.value:TQUANT::float        as TQUANT,
    item.value:PRICE::float         as PRICE,
    item.value:QPRICE::float        as QPRICE,
    SOURCE_DB::string               as SOURCE_DB

FROM {{ source('json', 'MED_PORDERITEMS_SUBFORM') }},
lateral flatten(input => DATA) item