select 
    INVOICE_NUMBER as "מספר חשבנית",
    DOC_PROJECT as "מספר פרויקט",
    INVOICE_DATE  as "Date",
    TOTAL_PRICE as "סכום חשבונית",
    id AS id_INVOICES,
    a.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"

from {{ ref('INVOICES') }} a

{{ join_valid_projects('a.DOC_PROJECT', 'a.SOURCE_DB') }}
