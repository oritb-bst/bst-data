-- מסך בן של מטבעות - שערי חליפין קודמים CURRHIS_SUBFORM
select
    item.value:CODE::string  as CODE, --שדה של האבא
    sub.value:EXCH::float    as EXCH,
    sub.value:CURDATE::date  as CURDATE,
    SOURCE_DB::STRING        as SOURCE_DB

from {{ source('json', 'CURRHIS_SUBFORM') }},
LATERAL FLATTEN(input => DATA) item,
LATERAL FLATTEN(input => item.value:CURRHIS_SUBFORM) sub