-- depends_on: {{ ref('PINVOICES_J_INC') }}

{{ config(
    materialized='table'
) }}

{% set relation_exists = false %}

{% if execute %}
  {% set check_query %}
    select count(*) from {{ this }} where 1=0
  {% endset %}

  {% set results = run_query(check_query) %}

  {% if results is not none %}
    {% set relation_exists = true %}
  {% endif %}
{% endif %}


{% if relation_exists %}

  with incoming_data as (
      select
          IVNUM       as INVOICE_NAME,
          PROJDOCNO   as PROJECT_NAME,
          IVDATE      as INVOICE_DATE,
          QPRICE      as QNT_BEFORE_DISCOUNT,
          DISPRICE,
          TOTPRICE,
          CALPRICE,
          STORNOFLAG  as IS_CANCELED,
          SUPNAME,    
          FINAL,
          STATDES     as INVOICE_STATUS,
          ORDNAME     as ORDER_NAME,
          DEBIT,
          DOCNO,
          UDATE,
          SOURCE_DB
      from {{ ref('PINVOICES_J_INC') }}
      where UDATE >= (select max(UDATE) from {{ this }})
  ),

  historical_unmodified_data as (
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

  select
      IVNUM       as INVOICE_NAME,
      PROJDOCNO   as PROJECT_NAME,
      IVDATE      as INVOICE_DATE,
      QPRICE      as QNT_BEFORE_DISCOUNT,
      DISPRICE,
      TOTPRICE,
      CALPRICE,
      STORNOFLAG  as IS_CANCELED,
      SUPNAME,    
      FINAL,
      STATDES     as INVOICE_STATUS,
      ORDNAME     as ORDER_NAME,
      DEBIT,
      DOCNO,
      UDATE,
      SOURCE_DB
  from {{ adapter.quote(target.database) }}.{{ adapter.quote(target.schema) }}.PINVOICES_STG

{% endif %}