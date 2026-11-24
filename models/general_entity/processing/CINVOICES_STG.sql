--חשבוניות ספק
select
    IV         as id,
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
    DETAILS,
    UDATE,
    SOURCE_DB,
    PAYDATE, 
    BALDATE,
    IFF(FINAL IS NULL, 'N', FINAL) as FINALFLAG,
    IFF(STORNOFLAG IS NULL, 'N', STORNOFLAG) as STORNOFLAG
from {{ ref ('CINVOICES_J') }}



