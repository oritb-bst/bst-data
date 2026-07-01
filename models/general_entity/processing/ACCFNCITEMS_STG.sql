--ACCFNCITEMS2_SUBFORM
-- קיימת פה בניית של שדה תאריך הנגזר משדה פרטים שמוקלד ידנית. לוקחים מפה תאריך. קיימת פה גם בניית דגל להראות מקרים בהם לא נמצא תאריך

WITH base AS (

    SELECT
        ACCOUNT,
        BALDATE,
        DETAILS,
        DEBIT,
        CREDIT,
        SOURCE_DB,
        STORNOFLAG,
        FNCNUM,

        CASE 
            WHEN source_db = 'BST' THEN 
                REGEXP_SUBSTR(
                    DETAILS,
                    '\\d{1,2}[./]\\d{2,4}'
                )
        END AS date_text

    FROM {{ ref('ACCFNCITEMS2_J') }}
)

SELECT
    ACCOUNT        as ACCOUNT_ID,
    BALDATE,
    FNCNUM,
    DETAILS        as ACCOUNT_DETAILS,
    DEBIT/1000     as ACCOUNT_DEBIT,
    CREDIT/1000    as ACCOUNT_CREDIT,
    SOURCE_DB,
    STORNOFLAG,
    date_text,

    CASE
    WHEN DETAILS ILIKE 'PQ%' THEN 0
    WHEN date_text IS NULL THEN 1
    ELSE 0
    END AS missing_date_flag,

    CASE
    WHEN DETAILS ILIKE 'PQ%' THEN DATE_TRUNC('MONTH', BALDATE)

    ELSE TRY_TO_DATE(
        '01.' ||
        REGEXP_REPLACE(
            REPLACE(date_text, '/', '.'),
            '\\.(\\d{2})$',
            '.20\\1'
        ),
        'DD.MM.YYYY'
    )
END AS execution_date

FROM base