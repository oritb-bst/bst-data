select 
    INVOICE_NUMBER as "מספר חשבנית",
    DOC_PROJECT as "מספר פרויקט",
    INVOICE_DATE as "תאריך חשבונית",
    TOTAL_PRICE as "סכום חשבונית",
    id 

from {{ ref('INVOICES_STG') }}