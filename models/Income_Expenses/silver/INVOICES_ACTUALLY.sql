--טבלה לצורך הרצה של אוטומציה
SELECT
    DOC_PROJECT as "מספר פרויקט",
    DATE_TRUNC('MONTH', INVOICE_DATE) AS "Date",
    INVOICES_ACTUALLY_NEW,
    INVOICES_ACTUALLY_EXPENSE_NEW ,
    a.SOURCE_DB  as "חברה",
    p.projtypedes as "סוג פרויקט אחרי סינון"
from {{ ref('INVOICES_ACTUALLY_STG') }} a

{{ join_valid_projects('a.DOC_PROJECT', 'a.SOURCE_DB') }}
