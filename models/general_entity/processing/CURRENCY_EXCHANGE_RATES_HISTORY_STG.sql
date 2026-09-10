-- מסך בן של מטבעות - שערי חליפין קודמים CURRHIS_SUBFORM
select
    CODE    as CURRENCY, --שדה של האבא
    EXCH    as EXCHANGE_RATE,
    CURDATE as EXCHANGE_RATE_DATE,
    SOURCE_DB
from {{ ref('CURRHIS_J') }}