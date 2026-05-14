SELECT
    DOC_PROJECT as "מספר פרויקט",
    INVOICE_DATE  as "Date",
    INVOICES_ACTUALLY_NEW,
    INVOICES_ACTUALLY_EXPENSE_NEW ,
    SOURCE_DB  as "חברה"
from {{ ref('INVOICES_ACTUALLY') }}