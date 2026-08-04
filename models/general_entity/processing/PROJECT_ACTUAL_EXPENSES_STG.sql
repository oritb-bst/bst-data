WITH base AS (

SELECT
    UPPER(Company) AS source_db,
    TO_DATE(SPLIT_PART(Control_Date, ' ', 1), 'DD/MM/YY') AS Control_Date,
    Project,
    Project_Desc,
    Sub_Chapter,
    Sub_Chapter_Desc,
    Resource,
    Resource_Desc,
    Doc_Type,
    Doc_Desc,
    Supplier_No,
    Supplier_Name,
    Doc_No,

    CASE
    WHEN REGEXP_COUNT(SPLIT_PART(Exec_Month_Date, ' ', 1), '/') = 1 THEN
        TO_DATE(
            '01/' || SPLIT_PART(Exec_Month_Date, ' ', 1),
            'DD/MM/YY'
        )
    ELSE
        TO_DATE(
            SPLIT_PART(Exec_Month_Date, ' ', 1),
            'DD/MM/YY'
        )
    END AS Exec_Month_Date,

    Part_No,
    Part_Desc,
    Doc_Quant,
    Factory_Unit,
    Unit_Price,
    Amount,
    Entity_Name,
    Control_Month,

    CASE
        WHEN Doc_Type IN ('קבספ', 'חסמ', 'חס', 'חסז', 'חזס') AND Resource LIKE '1021%' THEN 'בטון'
        WHEN Doc_Type IN ('קבספ', 'חסמ', 'חס', 'חסז', 'חזס') AND Resource LIKE '1022%' THEN 'ברזל'
        WHEN Doc_Type = 'מ' THEN 'ניהול אתר'
        WHEN Doc_Type = 'פ' THEN 'ניהול שונות'
        WHEN Doc_Type = 'PPC' THEN 'קבלנים'
        ELSE 'רכש'
    END AS Expense_Type,


    CASE
        WHEN Doc_Type <> 'PPC'
             AND Resource = 999999
        THEN 1
        ELSE 0
    END AS Project_Expenses_Exclude_Flag

FROM {{ source('txt', 'PROJECT_ACTUAL_EXPENSES') }}

)

SELECT *
FROM base