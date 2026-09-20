{{ config(
    materialized='incremental',
    unique_key=['INVOICE_NAME', 'SOURCE_DB'],
    incremental_strategy='merge',
    full_refresh=false
) }}

{% if is_incremental() %}

  -- הרצה שוטפת: MERGE רק של מנת הדלתא מול הטבלה הקיימת
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

  -- הרצה ראשונית / Full Refresh: בניית הטבלה מתוך מקור ההיסטוריה המלא
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
  from {{ source('processing', 'PINVOICES_STG') }}

{% endif %}