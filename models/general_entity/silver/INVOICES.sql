select 
    INVOICE_NUMBER,
    DOC_PROJECT,
    INVOICE_DATE,
    TOTAL_PRICE,
    id,
    SOURCE_DB

from {{ ref('INVOICES_STG') }}