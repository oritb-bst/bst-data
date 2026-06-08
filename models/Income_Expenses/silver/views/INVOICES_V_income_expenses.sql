select 
    INVOICE_NUMBER as "מספר חשבנית",
    DOC_PROJECT as "מספר פרויקט",
    INVOICE_DATE  as "Date",
    TOTAL_PRICE as "סכום חשבונית",
    id AS id_INVOICES,
    t.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"

from {{ ref('INVOICES') }} t

{{ join_valid_projects('t.DOC_PROJECT') }}
where t.SOURCE_DB = 'BST'

