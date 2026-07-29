WITH base AS (

SELECT
    UPPER(Company) AS source_db,
    Control_Date,
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
        -- פורמט חודש/שנה (05/24, 01/26)
        WHEN REGEXP_COUNT(Exec_Month_Date, '/') = 1 THEN
            TO_DATE(
                '01/' || Exec_Month_Date,
                'DD/MM/YY'
            )

        -- פורמט מלא יום/חודש/שנה (15/02/24)
        ELSE
            TO_DATE(
                Exec_Month_Date,
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
        WHEN Doc_Type IN ('קבספ', 'חסמ', 'חס', 'חסז', 'חזס')
             AND Resource LIKE '1021%'
        THEN Amount
        ELSE 0
    END AS "הוצאות בפועל בטון",

    CASE
        WHEN Doc_Type IN ('קבספ', 'חסמ', 'חס', 'חסז', 'חזס')
             AND Resource LIKE '1022%'
        THEN Amount
        ELSE 0
    END AS "הוצאות בפועל ברזל",

    CASE
        WHEN Doc_Type = 'מ'
        THEN Amount
        ELSE 0
    END AS "הוצאות בפועל ניהול אתר",

    CASE
        WHEN Doc_Type = 'פ'
        THEN Amount
        ELSE 0
    END AS "הוצאות בפועל ניהול שונות",

    CASE
        WHEN Doc_Type = 'PPC'
        THEN Amount
        ELSE 0
    END AS "הוצאות בפועל קבלנים",

    CASE
        WHEN Doc_Type IN ('קבספ', 'חסמ', 'חס', 'חסז', 'חזס')
             AND Resource LIKE '1021%'
        THEN Doc_Quant
        ELSE 0
    END AS "הוצאות בפועל כמות בטון",

    CASE
        WHEN Doc_Type IN ('קבספ', 'חסמ', 'חס', 'חסז', 'חזס')
             AND Resource LIKE '1022%'
        THEN Doc_Quant
        ELSE 0
    END AS "הוצאות בפועל כמות ברזל",

    CASE
        WHEN Doc_Type = 'מ'
        THEN Doc_Quant
        ELSE 0
    END AS "הוצאות בפועל כמות ניהול אתר",

    CASE
        WHEN Doc_Type = 'פ'
        THEN Doc_Quant
        ELSE 0
    END AS "הוצאות בפועל כמות ניהול שונות",

    CASE
        WHEN Doc_Type = 'PPC'
        THEN Doc_Quant
        ELSE 0
    END AS "הוצאות בפועל כמות קבלנים",

    CASE
        WHEN Doc_Type <> 'PPC'
             AND Resource = 999999
        THEN 1
        ELSE 0
    END AS Project_Expenses_Exclude_Flag

FROM {{ source('txt', 'PROJECT_ACTUAL_EXPENSES') }}

)

SELECT
    *,

    Amount
        - "הוצאות בפועל בטון"
        - "הוצאות בפועל ברזל"
        - "הוצאות בפועל ניהול שונות"
        - "הוצאות בפועל קבלנים"
        - "הוצאות בפועל ניהול אתר"
        AS "הוצאות בפועל רכש"

FROM base