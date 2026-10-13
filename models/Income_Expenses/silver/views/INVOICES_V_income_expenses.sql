select 
    INVOICE_NAME as "מספר חשבנית",
    PROJECT_NAME as "מספר פרויקט",
    INVOICE_DATE  as "Date",
    TOTPRICE as "סכום חשבונית",
    id AS id_INVOICES,
    a.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"

from {{ ref('CINVOICES_STG') }} a

{{ join_valid_projects('a.PROJECT_NAME', 'a.SOURCE_DB') }}
