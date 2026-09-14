-- בדיקה האם טבלת היעד כבר קיימת במסד הנתונים
{% set target_relation = adapter.get_relation(database=this.database, schema=this.schema, identifier=this.table) %}

with incoming_data as (
    select
        IVNUM      as INVOICE_NAME,
        PROJDOCNO  as PROJECT_NAME,
        IVDATE     as INVOICE_DATE,
        QPRICE     as QNT_BEFORE_DISCOUNT,
        DISPRICE,
        TOTPRICE,
        CALPRICE,
        STORNOFLAG as IS_CANCELED,
        SUPNAME,    
        FINAL,
        STATDES    as INVOICE_STATUS,
        ORDNAME    as ORDER_NAME,
        DEBIT,
        DOCNO,
        UDATE,
        SOURCE_DB
    from {{ ref('PINVOICES_J_INC') }}
    
    {% if target_relation is not none %}
    -- אם הטבלה קיימת: קח רק נתונים מיום העדכון האחרון והלאה
    where UDATE >= (select max(UDATE) from {{ this }})
    {% endif %}
)

{% if target_relation is not none %}

, historical_data as (
    select h.*
    from {{ this }} h
    left join incoming_data i
        on h.INVOICE_NAME = i.INVOICE_NAME
       and h.SOURCE_DB = i.SOURCE_DB
    where i.INVOICE_NAME is null
)

-- איחוד ההיסטוריה שלא השתנתה עם הנתונים החדשים
select * from historical_data
union all
select * from incoming_data

{% else %}

-- בריצה הראשונה (כשהטבלה עוד לא קיימת): קח את כל הנתונים מ-incoming_data
select * from incoming_data

{% endif %}