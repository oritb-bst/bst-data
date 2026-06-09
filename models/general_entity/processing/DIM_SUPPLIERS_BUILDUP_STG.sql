-- dim_suppliers_contractors.sql
-- מימד אחיד של ספקים וקבלנים שכל אחד מהם מגיע מטבלת המדד
-- ספקים מטבלת הזמנות רכש, וקבלנים מטבלת חשבונות קבלן
-- מביא את התיאור מה-MIMAD ואת סוג לפי מקור הטבלאות

-- ספקים מתוך PORDERS
SELECT DISTINCT
    p.SUPNAME  AS SUP_NAME,    -- שם הספק
    s.SUPDES   AS SUP_DES,     -- תיאור אמיתי מהמימד
    'ספק' AS SUP_TYPE,         -- סוג נקבע לפי מקור הטבלה
    p.SOURCE_DB                -- מקור רשומה
FROM {{ ref('PORDERS_J') }} p
LEFT JOIN {{ ref('SUPPLIERS_J') }} s
       ON p.SUPNAME = s.SUPNAME
WHERE p.STATDES NOT IN ('מבוטלת', 'טיוטא', 'מבוטל')
  AND p.SUPNAME IS NOT NULL
  AND p.SOURCE_DB='BLDUP'

UNION ALL

-- קבלנים מתוך MED_DOCUMENTS_P
SELECT DISTINCT
    m.SUPNAME    AS SUP_NAME,      -- שם הקבלן
    c.SUPDES     AS SUP_DES,       -- תיאור אמיתי מהמימד
    'קבלן' AS SUP_TYPE,      -- סוג נקבע לפי מקור הטבלה
    m.SOURCE_DB                    -- מקור רשומה
FROM {{ ref('MED_DOCUMENTS_P_J') }} m
LEFT JOIN {{ ref('SUPPLIERS_J') }} c
       ON m.SUPNAME = c.SUPNAME
WHERE m.STATDES NOT IN ('מבוטלת', 'טיוטא')
  AND m.SUPNAME IS NOT NULL
  AND c.SOURCE_DB='BLDUP'