SELECT
    DOC_PROJECT as "מספר פרויקט",
    INVOICE_DATE  as "Date",
    INVOICES_ACTUALLY_NEW,
    INVOICES_ACTUALLY_EXPENSE_NEW ,
    t.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('INVOICES_ACTUALLY') }} t

{{ join_valid_projects('t.DOC_PROJECT') }}
where t.SOURCE_DB = 'BST'

