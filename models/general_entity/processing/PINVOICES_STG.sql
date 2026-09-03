--חשבוניות ספק מרכזות
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
from {{ ref ('PINVOICES_J') }}