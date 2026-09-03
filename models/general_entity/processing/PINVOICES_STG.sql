--טבלה עם מנגנון אינקרמנטלי
--חשבוניות ספק מרכזות
{{ config(
    materialized='incremental',
    unique_key=['INVOICE_NAME', 'SOURCE_DB'],
    incremental_strategy='merge'
) }}

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
    SOURCE_DB
from {{ ref ('PINVOICES_J_INC') }}