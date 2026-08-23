-- חשבון חלקי (מזמין)
select
    execution_date as "Date",
    PROJECT_DOCNO  as "מספר פרויקט",
    DOC,
    ORDNAME        as "מספר חוזה מזמין",
    CUSTNAME       as "מס. לקוח",
    DISPRICE       as "סכום מוגש - מחיר אחרי הנחה",
    EXPECTPAY      as "סכום תשלום צפוי",
    STATDES        as "סטטוס חשבון חלקי מזמין",
    BOOKNUM        as "מספר חשבון חלקי",
    t.SOURCE_DB      as "חברה",
    coalesce(nullif(EXPECTPAY/1000, 0), DISPRICE/1000) as "סכום תשלום",

from {{ ref('MED_DOCUMENTS_D_STG') }} t

{{ join_bst_projects_budget_control('PROJECT_DOCNO', 't.SOURCE_DB') }}