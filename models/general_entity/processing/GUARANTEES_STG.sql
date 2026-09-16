--MEDR_GUARANTEES
select
    PROJNO   as PROJECT_NAME,
    PROJDES  as PROJECT_DES,
    BANKCODE as BANK_CODE,
    BANKNAME as BANK_NAME,
    GUARANTYPEDES as GUARANTEE_TYPE_DES,
    BANKREF       as BANK_GUARANTEE_REFERENCE,
    ACCDES        as ACC_DES,
    GSUM          as GUARANTEE_AMOUNT,
    EXCHSUM       as REVALUED_GUARANTEE_AMOUNT,
    SDATE         as GUARANTEE_START_DATE,
    EXPDATE       as GUARANTEE_END_DATE,
    CDES          as GUARANTEED_ENTITY_NAME, --שם הנערב
    GUARANTYPENAME as GUARANTEE_TYPE_NAME,
    STATDES        as GUARANTEE_STATUS,
    DOCNO          as GUARANTEE_NAME, --מספר ערבות
    case when GUARANTYPENAME in (4,6,13,15,20) then 'מזמין'
         when GUARANTYPENAME in (2,3,21) then 'קבלן' else 'אחר' end as GUARANTEE_PARTY,
    b.CREDIT_LIMIT,
    b.DEPOSIT,
    g.SOURCE_DB
from {{ ref('MEDR_GUARANTEES_J') }} g

left join {{ source('csv', 'BANK_CREDITS_DEPOSITS') }} b
    on g.BANKCODE = b.BANK_CODE
    and g.SOURCE_DB = b.SOURCE_DB