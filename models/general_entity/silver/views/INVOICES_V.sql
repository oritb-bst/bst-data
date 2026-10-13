select 
    INVOICE_NAME as "מספר חשבנית",
    PROJECT_NAME as "מספר פרויקט",
    INVOICE_DATE  as "Date",
    TOTPRICE as "סכום חשבונית",
    id AS id_INVOICES,
    SOURCE_DB  as "חברה"

from {{ ref('CINVOICES_STG') }}