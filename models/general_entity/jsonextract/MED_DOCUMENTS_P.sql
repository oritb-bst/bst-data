SELECT
    item.value:PROJDOCNO::string    as PROJDOCNO,
    item.value:SUPNAME::string      as SUPNAME,
    item.value:BOOKNUM::string      as BOOKNUM,
    item.value:CURDATE::date        as CURDATE,
    SOURCE_DB::string               as SOURCE_DB,
    item.value:DISPRICE::float      as DISPRICE,
    item.value:STATDES::string      as STATDES

FROM {{ source('json', 'MED_DOCUMENTS_P') }},
lateral flatten(input => DATA) item