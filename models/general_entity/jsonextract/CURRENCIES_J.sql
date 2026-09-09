--מטבעות
SELECT
    item.value:CODE::string AS CODE,
    item.value:NAME::string AS NAME,
    SOURCE_DB::string       AS SOURCE_DB

FROM {{ source('json', 'CURRENCIES') }},
LATERAL FLATTEN(input => DATA) item