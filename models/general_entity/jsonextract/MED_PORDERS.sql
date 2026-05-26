select
    item.value:DOCPROJ::number              as DOCPROJ,
    item.value:PROJDOCNO::string            as PROJDOCNO,
    item.value:SUPNAME::string              as SUPNAME,
    item.value:CDES::string                 as CDES,
    item.value:ZCBS_PRICETOAPP::float       as ZCBS_PRICETOAPP,
    item.value:MED_TYPE::string             as MED_TYPE,
    item.value:DISPRICE::float              as DISPRICE,
    item.value:CURDATE::date                as CURDATE,
    source_db::string                       as SOURCE_DB,
    item.value:ORDNAME::string              as ORDNAME,
    item.value:STATDES::string              as STATDES

from {{ source('json', 'MED_PORDERS') }},
lateral flatten(input => DATA) item