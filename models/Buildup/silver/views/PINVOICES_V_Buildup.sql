--ויו לבילדאפ לפי בקשה של דודי
select 
    t.INVOICE_NAME as "מספר חשבנית",
    t.PROJECT_NAME as "פרויקט",
    d.PROJDES as "תאור פרויקט",
    t.INVOICE_DATE as "תאריך",
    t.TOTPRICE as "סהכ לתשלום",
    t.CALPRICE as "סכום מחושב",
    t.DISPRICE as "סכום לפני מעמ",
    t.SUPNAME as "מספר ספק",
    s.SUP_DES as "תאור ספק",
    t.DEBIT as "חיוב/זיכוי",
    t.INVOICE_STATUS as "סטטוס",
    t.DOCNO as "תעודה",
    t.SOURCE_DB as "חברה"
from {{ ref('PINVOICES_STG') }} t

left join {{ ref('DIM_SUPPLIERS_STG') }} s
    on t.SUPNAME = s.SUP_NAME 
   and t.SOURCE_DB = s.SOURCE_DB 

left join {{ ref('DIM_PROJECTS_STG') }} d
    on t.PROJECT_NAME = d.DOCNO
    and t.SOURCE_DB = d.SOURCE_DB 

{{ join_valid_projects_buildup('t.PROJECT_NAME', 't.SOURCE_DB') }}

where {{ filter_last_n_years('t.INVOICE_DATE') }} --סינון שנים