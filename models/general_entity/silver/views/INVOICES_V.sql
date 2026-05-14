select 
    INVOICE_NUMBER as "מספר חשבנית",
    DOC_PROJECT as "מספר פרויקט",
    INVOICE_DATE  as "Date",
    TOTAL_PRICE as "סכום חשבונית",
    id AS id_INVOICES,
    SOURCE_DB  as "חברה"

from {{ ref('INVOICES') }}