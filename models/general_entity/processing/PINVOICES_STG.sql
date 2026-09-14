{{ config(
    materialized='table'
) }}

-- בדיקה דינמית שבודקת באופן אקטיבי אם הטבלה קיימת ב-Database וב-Schema הנוכחיים של הריצה
{% set relation_exists = false %}
{% if execute %}
    {% set target_relation = adapter.get_relation(database=this.database, schema=this.schema, identifier=this.table) %}
    {% if target_relation is not none %}
        {% set relation_exists = true %}
    {% endif %}
{% endif %}

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
    
    {% if relation_exists %}
    where UDATE >= (select max(UDATE) from {{ this }})
    {% endif %}
)

{% if relation_exists %}

, historical_unmodified_data as (
    select h.*
    from {{ this }} h
    left join incoming_data i
        on h.INVOICE_NAME = i.INVOICE_NAME
       and h.SOURCE_DB = i.SOURCE_DB
    where i.INVOICE_NAME is null
)

select * from historical_unmodified_data
union all
select * from incoming_data

{% else %}

select * from incoming_data

{% endif %}