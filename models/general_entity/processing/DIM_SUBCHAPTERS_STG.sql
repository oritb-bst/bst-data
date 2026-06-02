--COSTCENTERS3Q
SELECT
    COSTCNAME as SUB_CHAPTER_NAME,
	COSTCDES  as SUB_CHAPTER_DES,
    CASE 
        WHEN COSTCNAME IN ('991','993') THEN NULL 
        ELSE COSTCNAME
    END AS SUB_CHAPTER_NAME_FOR_BUD_CONTROL,
    CASE 
        WHEN COSTCNAME = '991' THEN 'התייקרות עתידית'
        WHEN COSTCNAME = '991' THEN 'התייקרות מצטבר'
        WHEN COSTCNAME = '993' THEN 'קיזוזי חוזי בפועל'
        WHEN COSTCNAME = '993' THEN 'קיזוז חוזי עתידי'
        WHEN COSTCNAME = '993' THEN 'קיזוז ידני בפועל'
        WHEN COSTCNAME = '993' THEN 'ידני עתידי'
        ELSE COSTCDES
    END AS SUB_CHAPTER_DES_FOR_BUD_CONTROL,
	SOURCE_DB
FROM {{ ref('COSTCENTERS3Q_J') }}