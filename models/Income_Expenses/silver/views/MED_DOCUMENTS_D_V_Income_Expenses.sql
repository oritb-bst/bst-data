--מודול מזמין

SELECT
    EXECUTION_DATE as Date,
    PROJECT_DOCNO as "מספר פרויקט",
    ORDNAME as "מספר חוזה מזמין",
    CUSTNAME as "מס. לקוח",
    DISPRICE as "סכום מוגש - מחיר אחרי הנחה",
    MED_APPQPRICE as "סכום מאושר שוטף",
    EXPECTPAY as "סכום תשלום צפוי",
    STATDES as "סטטוס",
    BOOKNUM as "מספר חשבון חלקי",
    a.SOURCE_DB  as "חברה"
    
    
FROM {{ ref('MED_DOCUMENTS_D_STG') }} a

{{ join_valid_projects('a.PROJECT_DOCNO', 'a.SOURCE_DB') }}


