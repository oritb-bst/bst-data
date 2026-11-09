--MED_DOCUMENTS_P
with ranked_documents as ( --לטובת חילוץ חשבון חלקי אחרון (rn=1)
    select
        p.*,
        row_number() over (
            partition by p.PROJDOCNO, p.SUPNAME, p.SOURCE_DB
            order by case when p.STATDES in ('ממתין לאישור', 'מאושר') then 0 else 1 end,
                p.CURDATE desc, p.DOCNO desc) as rn
    from {{ ref('MED_DOCUMENTS_P_J') }} p
    where p.STATDES not in ('מבוטלת')
)

select
    p.PROJDOCNO as PROJECT_NAME,
    p.SUPNAME as SUP_NAME,
    p.BOOKNUM as PARTIAL_INVOICE_NUM,
    p.CURDATE,
    p.DISPRICE as PRICE_AFTER_DISCOUNT_INV,
    p.STATDES as STATUS_INV,
    p.FLAG as IS_BILLABLE,
    p.IVALL as IS_INVOICED_FLAG,
    p.ZCBS_IVNUM as SUP_INVOICE_NUMBER,
    p.ZBST_IVNUM as SUP_PAYMENT_NUMBER,
    case when p.IVALL = 'Y' then 'שולם'
         when p.IVALL = 'N' then 'לא שולם' else p.IVALL end as IS_INVOICED,
    p.DOCNO as PARTIAL_INVOICE_NAME,
    p.MED_EXEMONTH as EXECUTION_MONTH,
    p.MED_DOCTOTPRICE as CUMULATIVE_ACCOUNT,
    case when p.rn = 1 and p.STATDES in ('ממתין לאישור', 'מאושר') then p.MED_DOCTOTPRICE else null end as MAX_CUMULATIVE_ACCOUNT, --סכום החשבון המצטבר האחרון בסטטוס המבוקש
    r.RET_PRICE as RETENTION_AMOUNT, --עכבון ברמת החשבון
    case when p.rn = 1 and p.STATDES in ('ממתין לאישור', 'מאושר') then r.RET_PRICE else null end as MAX_RETENTION_AMOUNT, --עכבון החשבון האחרון בסטטוס המבוקש - פעם אחת לקבלן
    p.SOURCE_DB
from ranked_documents p

left join {{ ref('CONTRACTOR_RETENTIONS_STG') }} r
    on p.PROJDOCNO = r.PROJECT_NAME
   and p.DOCNO = r.PARTIAL_INVOICE_NAME
   and p.SOURCE_DB = r.SOURCE_DB
   and trim(to_varchar(r.SUB_TOPIC_NAME)) = '490000'
