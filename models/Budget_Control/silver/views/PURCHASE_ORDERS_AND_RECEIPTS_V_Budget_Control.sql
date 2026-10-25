--פיתוח של הזמנות עם קבלות סחורה + הזמנות ללא
WITH GOODS_RECEIPTS AS ( --קבלות סחורה
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY
                "מספר פרויקט",
                "חברה",
                "מספר ספק",
                "מספר הזמנת רכש"
            ORDER BY "Date", "מספר קבלת סחורה") AS RN
    FROM {{ ref('GOODS_RECEIPTS_V_Budget_Control') }}
),

PURCHASE_ORDERS AS ( --הזמנות רכש
    SELECT *
    FROM {{ ref('PURCHASE_ORDERS_V_Budget_Control') }}
),

--קבלות סחורה עם נתוני ההזמנה
RECEIPTS_WITH_ORDERS AS (
    SELECT
        GR."מספר פרויקט",
        GR."מספר ספק",
        GR."Date",
        GR."חברה",
        GR."מספר הזמנת רכש",
        GR."מספר קבלת סחורה",
        GR."מחיר קבלת סחורה מספק אחרי הנחה",
        GR."סטטוס קבלת סחורה מספק",
        GR."דגל קבלת סחורה חויבה",
        CASE WHEN GR.RN = 1 THEN PO."מחיר הזמנת רכש אחרי הנחה" END AS "מחיר הזמנת רכש אחרי הנחה",
        PO."סטטוס הזמנת רכש"
    FROM GOODS_RECEIPTS GR

    LEFT JOIN PURCHASE_ORDERS PO
        ON GR."מספר פרויקט" = PO."מספר פרויקט"
        AND GR."חברה" = PO."חברה"
        AND GR."מספר ספק" = PO."מספר ספק"
        AND GR."מספר הזמנת רכש" = PO."מספר הזמנת רכש"
),

-- הזמנות רכש שאין להן קבלות סחורה
ORDERS_WITHOUT_RECEIPTS AS (
    SELECT
        PO."מספר פרויקט",
        PO."מספר ספק",
        PO."Date",
        PO."חברה",
        PO."מספר הזמנת רכש",
        NULL AS "מספר קבלת סחורה",
        NULL AS "מחיר קבלת סחורה מספק אחרי הנחה",
        NULL AS "סטטוס קבלת סחורה מספק",
        NULL AS "דגל קבלת סחורה חויבה",
        PO."מחיר הזמנת רכש אחרי הנחה",
        PO."סטטוס הזמנת רכש"
    FROM PURCHASE_ORDERS PO

    WHERE NOT EXISTS (
        SELECT 1
        FROM GOODS_RECEIPTS GR
        WHERE GR."מספר פרויקט" = PO."מספר פרויקט"
          AND GR."חברה" = PO."חברה"
          AND GR."מספר ספק" = PO."מספר ספק"
          AND GR."מספר הזמנת רכש" = PO."מספר הזמנת רכש"))

SELECT * FROM RECEIPTS_WITH_ORDERS

UNION ALL

SELECT * FROM ORDERS_WITHOUT_RECEIPTS
