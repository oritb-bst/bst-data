--דוח שעמית מוציא - רק נתוני TODAY
SELECT 
    source_db        AS "חברה",
    Control_Date     AS "Date",
    Project          AS "מספר פרויקט",
    Project_Desc     AS "תיאור פרויקט",
    Sub_Chapter      AS "מספר תת פרק",
    Sub_Chapter_Desc AS "תיאור תת פרק",
    'Resource'       AS "מספר משאב",
    Resource_Desc    AS "תיאור משאב",
    Doc_Type         AS "סוג תעודה",
    Doc_Desc         AS "תיאור תעודה",
    Supplier_No      AS "מספר ספק",
    Supplier_Name    AS "שם ספק",
    Doc_No           AS "מספר תעודה",
    CASE WHEN Doc_No LIKE 'PO%' THEN Doc_No END AS "מספר הזמנת רכש",
    CASE WHEN Doc_No LIKE 'GR%' THEN Doc_No END AS "מספר קבלת סחורה",
    Exec_Month_Date AS "תאריך/חודש ביצוע",
    Part_No         AS "מק'ט",
    Part_Desc       AS "תיאור מוצר",
    Doc_Quant       AS "כמות בתעודה",
    Factory_Unit    AS "יח' מפעל",
    Unit_Price      AS "מחיר יח'",
    Amount          AS "סכום",
    Expense_Type    AS "סוג הוצאה",
    Project_Expenses_Exclude_Flag,
    Control_Month,
    Entity_Name
FROM {{ ref('PROJECT_ACTUAL_EXPENSES_STG') }} a

{{ join_bst_projects_without_sourceDB_budget_control('Project') }}