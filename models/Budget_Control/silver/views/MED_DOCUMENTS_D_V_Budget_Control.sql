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
    coalesce(nullif(d.EXPECTPAY, 0), d.DISPRICE) as "סכום תשלום",

    p."פרויקט_ID"

from {{ ref('MED_DOCUMENTS_D_STG') }} d

inner join {{ ref('DIM_PROJECTS_V_Budget_Control') }} p
    on d.PROJECT_DOCNO = p."מספר פרויקט"
   and d.SOURCE_DB = p."חברה"