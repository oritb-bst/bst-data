select 
    INVOICE_NAME as "מספר חשבונית",
    PROJECT_NAME as "מספר פרויקט",
    INVOICE_DATE  as "Date",
    TOTPRICE as "סכום חשבונית",
    DISPRICE as "מחיר אחרי הנחה",
    STATDES as "סטטוס",
    DETAILS as "פרטים",
    FINALFLAG as "דגל סופית",
    STORNOFLAG as "דגל סטורנו",
    a.SOURCE_DB  as "חברה"
from {{ ref('CINVOICES_STG') }} a

{{ join_valid_projects_buildup('a.PROJECT_NAME', 'a.SOURCE_DB') }} 