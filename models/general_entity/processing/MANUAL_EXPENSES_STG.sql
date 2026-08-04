SELECT
    DATABASE as source_db,
    PROJECT_NUMBER as Project,
    EXPENSES_DATE as Exec_Month_Date,
    EXPENSES_DESCRIPTION,
    EXPENSES_LINE_CODE,
    EXPENSES_TYPE,

    CASE
        WHEN EXPENSES_TYPE = 'בטון'
        THEN EXPENSES_AMOUNT
        ELSE 0
    END AS "הוצאות בפועל בטון",

    CASE
        WHEN EXPENSES_TYPE = 'בטון'
        THEN EXPENSES_QTY
        ELSE 0
    END AS "הוצאות בפועל כמות בטון",

    CASE
        WHEN EXPENSES_TYPE = 'ברזל'
        THEN EXPENSES_AMOUNT
        ELSE 0
    END AS "הוצאות בפועל ברזל",

    CASE
        WHEN EXPENSES_TYPE = 'ברזל'
        THEN EXPENSES_QTY
        ELSE 0
    END AS "הוצאות בפועל כמות ברזל",

    CASE
        WHEN EXPENSES_TYPE = 'קבלנים'
        THEN EXPENSES_AMOUNT
        ELSE 0
    END AS "הוצאות בפועל קבלנים",

    CASE
        WHEN EXPENSES_TYPE = 'קבלנים'
        THEN EXPENSES_QTY
        ELSE 0
    END AS "הוצאות בפועל כמות קבלנים",

    CASE
        WHEN EXPENSES_TYPE = 'ניהול אתר'
        THEN EXPENSES_AMOUNT
        ELSE 0
    END AS "הוצאות בפועל ניהול אתר",

    CASE
        WHEN EXPENSES_TYPE = 'ניהול אתר'
        THEN EXPENSES_QTY
        ELSE 0
    END AS "הוצאות בפועל כמות ניהול אתר",

    CASE
        WHEN EXPENSES_TYPE = 'ניהול שונות'
        THEN EXPENSES_AMOUNT
        ELSE 0
    END AS "הוצאות בפועל ניהול שונות",

    CASE
        WHEN EXPENSES_TYPE = 'ניהול שונות'
        THEN EXPENSES_QTY
        ELSE 0
    END AS "הוצאות בפועל כמות ניהול שונות",

    CASE
        WHEN EXPENSES_TYPE = 'רכש'
        THEN EXPENSES_AMOUNT
        ELSE 0
    END AS "הוצאות בפועל רכש",

    CASE
        WHEN EXPENSES_TYPE = 'רכש'
        THEN EXPENSES_QTY
        ELSE 0
    END AS "הוצאות בפועל כמות רכש",

    EXPENSES_AMOUNT,
    EXPENSES_QTY

FROM {{ source('csv', 'MANUAL_EXPENSES') }}