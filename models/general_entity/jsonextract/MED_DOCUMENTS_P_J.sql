SELECT
    item.value:PROJDOCNO::string    as PROJDOCNO,
    item.value:SUPNAME::string      as SUPNAME,
    item.value:BOOKNUM::string      as BOOKNUM,
    item.value:CURDATE::date        as CURDATE,
    SOURCE_DB::string               as SOURCE_DB,
    item.value:DISPRICE::float      as DISPRICE,
    item.value:STATDES::string      as STATDES,
    item.value:FLAG::varchar        as FLAG,
    item.value:IVALL::varchar       as IVALL,
    item.value:ZCBS_IVNUM::varchar  as ZCBS_IVNUM

FROM {{ source('json', 'MED_DOCUMENTS_P') }},
lateral flatten(input => DATA) item