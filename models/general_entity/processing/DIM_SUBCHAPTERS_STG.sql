--COSTCENTERS3Q
SELECT
    COSTCNAME as SUB_CHAPTER_NAME,
	COSTCDES  as SUB_CHAPTER_DES,
    case 
        when COSTCNAME = '991, 993' then null
        else COSTCNAME
    end as SUB_CHAPTER_CODE_FOR_BUD_CONTROL,
    case 
        when COSTCNAME = '991, 993' then 'התייקרות עתידית'
        when COSTCNAME = '991, 993' then 'התייקרות מצטבר'
        when COSTCNAME = '991, 993' then 'קיזוזי חוזי בפועל'
        when COSTCNAME = '991, 993' then 'קיזוז חוזי עתידי'
        when COSTCNAME = '991, 993' then 'קיזוז ידני בפועל'
        when COSTCNAME = '991, 993' then 'ידני עתידי'
        else COSTCDES
    end as SUB_CHAPTER_DES_FOR_BUD_CONTROL,
	SOURCE_DB
FROM {{ ref('COSTCENTERS3Q_J') }}