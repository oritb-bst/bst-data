SELECT
    a.source_db AS "חברה",
    a.Control_Date AS "תאריך בקרה",
    a.Project AS "מספר פרויקט",
    a.Project_Desc AS "תאור פרויקט",
    a.Sub_Chapter AS "תת פרק",
    a.Sub_Chapter_Desc AS "תאור תת פרק",
    a.Resource AS "משאב",
    a.Resource_Desc AS "תאור משאב",
    a.Doc_Type AS "סוג תעודה",
    a.Doc_Desc AS "תאור תעודה",
    a.Supplier_No AS "מס' ספק",
    a.Supplier_Name AS "שם ספק",
    a.Doc_No AS "מספר תעודה",
    a.Exec_Month_Date AS "Date",
    a.Part_No AS "מק'ט",
    a.Part_Desc AS "תאור מוצר",
    a.Doc_Quant AS "כמות בתעודה",
    a.Factory_Unit AS "יח' מפעל",
    a.Unit_Price AS "מחיר יח'",
    a.Amount AS "סכום",
    a.Expense_Type as "סוג הוצאה",
    a.Project_Expenses_Exclude_Flag,
    a.Entity_Name,
    p.projtypedes AS "סוג פרויקט אחרי סינון"

FROM {{ ref('PROJECT_ACTUAL_EXPENSES_STG') }} a


{{ join_valid_projects('a.Project', 'a.source_db') }}

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
    NULL AS "יח' מפעל",
    NULL AS "מחיר יח'",
    EXPENSES_TYPE AS "סוג הוצאה",
    EXPENSES_AMOUNT AS "סכום",
    EXPENSES_QTY AS "כמות בתעודה",
    0 AS Project_Expenses_Exclude_Flag,
    NULL AS Entity_Name,
    NULL AS "סוג פרויקט אחרי סינון"

FROM {{ ref('MANUAL_EXPENSES_STG') }}