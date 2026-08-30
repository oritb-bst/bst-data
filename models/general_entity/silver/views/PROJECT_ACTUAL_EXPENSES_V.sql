SELECT
    source_db AS "חברה",
    Control_Date AS "תאריך בקרה",
    Project AS "מספר פרויקט",
    Project_Desc AS "תאור פרויקט",
    Sub_Chapter AS "תת פרק",
    Sub_Chapter_Desc AS "תאור תת פרק",
    Resource AS "משאב",
    Resource_Desc AS "תאור משאב",
    Doc_Type AS "סוג תעודה",
    Doc_Desc AS "תאור תעודה",
    Supplier_No AS "מס' ספק",
    Supplier_Name AS "שם ספק",
    Doc_No AS "מספר תעודה",
    Exec_Month_Date AS "Date",
    Part_No AS "מק'ט",
    Part_Desc AS "תאור מוצר",
    Doc_Quant AS "כמות בתעודה",
    Factory_Unit AS "יח' מפעל",
    Unit_Price AS "מחיר יח'",
    Amount AS "סכום",
    Expense_Type as "סוג הוצאה",
    Project_Expenses_Exclude_Flag,
    Entity_Name

FROM {{ ref('PROJECT_ACTUAL_EXPENSES_STG') }} 

WHERE Doc_Type<>'CO'

UNION ALL

SELECT
    SOURCE_DB AS "חברה",
    CAST(NULL AS DATE) AS "תאריך בקרה",
    PROJECT AS "מספר פרויקט",
    NULL AS "תאור פרויקט",
    NULL AS "תת פרק",
    NULL AS "תאור תת פרק",
    NULL AS "משאב",
    NULL AS "תאור משאב",
    NULL AS "סוג תעודה",
    EXPENSES_DESCRIPTION AS "תאור תעודה",
    NULL AS "מס' ספק",
    NULL AS "שם ספק",
    NULL AS "מספר תעודה",
    Exec_Month_Date AS "Date",
    NULL AS "מק'ט",
    NULL AS "תאור מוצר",
    EXPENSES_QTY AS "כמות בתעודה",
    NULL AS "יח' מפעל",
    NULL AS "מחיר יח'",
    EXPENSES_AMOUNT AS "סכום",
    EXPENSES_TYPE AS "סוג הוצאה",
    0 AS Project_Expenses_Exclude_Flag,
    NULL AS Entity_Name

FROM {{ ref('MANUAL_EXPENSES_STG') }}


  