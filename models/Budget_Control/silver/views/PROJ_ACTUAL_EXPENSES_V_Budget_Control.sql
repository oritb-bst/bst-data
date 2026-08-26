SELECT --דוח שעמית מוציא
    a.source_db AS "חברה",
    a.Control_Date AS "תאריך בקרה",
    a.Project AS "מספר פרויקט",
    a.Project_Desc AS "תיאור פרויקט",
    a.Sub_Chapter AS "מספר תת פרק",
    a.Sub_Chapter_Desc AS "תיאור תת פרק",
    a.Resource AS "מספר משאב",
    a.Resource_Desc AS "תיאור משאב",
    a.Doc_Type AS "סוג תעודה",
    a.Doc_Desc AS "תיאור תעודה",
    a.Supplier_No AS "מספר ספק",
    a.Supplier_Name AS "שם ספק",
    a.Doc_No AS "מספר תעודה",
    CASE WHEN a.Doc_No LIKE 'PO%' THEN a.Doc_No END AS "מספר הזמנת רכש",
    CASE WHEN a.Doc_No LIKE 'GR%' THEN a.Doc_No END AS "מספר קבלת סחורה",
    a.Exec_Month_Date AS "תאריך/חודש ביצוע",
    a.Part_No AS "מק'ט",
    a.Part_Desc AS "תיאור מוצר",
    a.Doc_Quant AS "כמות בתעודה",
    a.Factory_Unit AS "יח' מפעל",
    a.Unit_Price AS "מחיר יח'",
    a.Amount AS "סכום",
    a.Expense_Type as "סוג הוצאה",
    a.Project_Expenses_Exclude_Flag,
    a.Control_Month,
    a.Entity_Name

FROM {{ ref('PROJECT_ACTUAL_EXPENSES_STG') }} a

{{ join_bst_projects_without_sourceDB_budget_control('a.Project') }}