WITH mapping AS (
    SELECT '991' AS COSTCNAME, 'התייקרות עתידית' AS NEW_DESC
    UNION ALL
    SELECT '991', 'התייקרות מצטבר'
    UNION ALL
    SELECT '993', 'קיזוז חוזי בפועל'
    UNION ALL
    SELECT '993', 'קיזוז חוזי עתידי'
    UNION ALL
    SELECT '993', 'קיזוז ידני בפועל'
    UNION ALL
    SELECT '993', 'ידני עתידי'
)

SELECT
    c.COSTCNAME AS SUB_CHAPTER_NAME,
    c.COSTCDES  AS SUB_CHAPTER_DES,
    CASE WHEN c.COSTCNAME IN ('991', '993') THEN NULL ELSE c.COSTCNAME END AS SUB_CHAPTER_NAME_FOR_BUD_CONTROL,
    COALESCE(m.NEW_DESC, c.COSTCDES) AS SUB_CHAPTER_DES_FOR_BUD_CONTROL,
    c.SOURCE_DB
FROM {{ ref('COSTCENTERS3Q_J') }} c
LEFT JOIN mapping m
    ON c.COSTCNAME = m.COSTCNAME