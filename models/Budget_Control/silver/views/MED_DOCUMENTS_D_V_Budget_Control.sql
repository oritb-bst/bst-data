-- חשבון חלקי (מזמין)
select
    d.execution_date as "Date",
    d.PROJECT_DOCNO  as "מספר פרויקט",
    d.DOC,
    d.ORDNAME        as "מספר חוזה מזמין",
    d.CUSTNAME       as "מס. לקוח",
    d.DISPRICE       as "סכום מוגש - מחיר אחרי הנחה",
    d.EXPECTPAY      as "סכום תשלום צפוי",
    d.STATDES        as "סטטוס חשבון",
    d.BOOKNUM        as "מספר חשבון חלקי",
    d.SOURCE_DB      as "חברה",

    pr.DOC           as "פרויקט_ID"

from {{ ref('MED_DOCUMENTS_D_STG') }} d

left join {{ ref('DIM_PROJECTS_STG') }} pr
    on d.PROJECT_DOCNO = pr.DOCNO
   and d.SOURCE_DB = pr.SOURCE_DB

{{ join_bst_projects_budget_control(
    'pr.DOC',
    'd.SOURCE_DB'
) }}