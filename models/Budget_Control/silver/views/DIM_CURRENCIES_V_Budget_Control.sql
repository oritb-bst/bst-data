-- CURRENCIES מטבעות
select
    CURRENCY     as "מטבע",
    CURRENCY_DES as "תיאור מטבע",
    SOURCE_DB    as "חברה"
from {{ ref('DIM_CURRENCIES_STG') }} 