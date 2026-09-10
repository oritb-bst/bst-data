-- מסך בן של מטבעות - שערי חליפין קודמים CURRHIS_SUBFORM
select
    CURRENCY           as "מטבע", --שדה של האבא
    EXCHANGE_RATE      as "שער חליפין",
    EXCHANGE_RATE_DATE as "תאריך שער חליפין",
    EXCHANGE_RATE_DATE as "Date",
    SOURCE_DB          as "חברה"
from {{ ref('CURRENCY_EXCHANGE_RATES_HISTORY_STG') }}