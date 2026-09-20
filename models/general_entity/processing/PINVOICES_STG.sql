-- depends_on: {{ ref('PINVOICES_J_INC') }}

{{ config(
    materialized='incremental',
    unique_key=['INVOICE_NAME', 'SOURCE_DB'],
    incremental_strategy='merge',
    full_refresh=false
) }}

{# בדיקה האם הטבלה קיימת פיזית ב-DWH #}
{% set target_relation = adapter.get_relation(this.database, this.schema, this.table) %}
{% set relation_exists = target_relation is not none %}

{% if is_incremental() and relation_exists %}

  -- הרצה שוטפת: מושכים מנת דלתא מ-PINVOICES_J_INC
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

{% else %}

  -- הרצה ראשונית: קריאה מוגנת במירכאות לפי הסביבה הפעילה (DEV / UAT / PROD)
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
  from "{{ target.database }}"."{{ target.schema }}".PINVOICES_STG

{% endif %}