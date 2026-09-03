--טבלה דינאמית - DBT יתייחס אליה רק בפעם הראשונה ויקים אותה, 
-- בריצות הבאות הוא יתעלם ממנה. מי שאחראי על עדכון תוכן הטבלה זה הסנואפלייק
--on_configuration_change - רק אם יהיה שינוי קונפיגורציה ה DBT יריץ אותה מחדש, בלי למחוק את התוכן

{{ config(
    enabled = false
) }}

{{ config(
    materialized='dynamic_table',
    snowflake_warehouse='COMPUTE_WH',
    target_lag='1 day', 
    on_configuration_change='apply' 
) }}
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