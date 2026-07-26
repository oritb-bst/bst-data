--select
--    "PERIOD" as BUD_CONTROL_PERIOD_ID,
--    DOC      as PROJECT_ID,
--    DOCNO    as PROJECT_NAME,
--    CONMONTH as BUD_CONTROL_MONTH,
--    CONDATE  as BUD_CONTROL_DATE,
--    CASE
--    WHEN TRIM(CLOSED) = 'Y' THEN '1'
--    ELSE '0' END AS IS_CLOSED, --דגל האם התקציב סגור
--    CURVERSION,
--    SOURCE_DB
--from {{ ref('BUD_CONTROLPERIODS_Z_J') }}


WITH budget_periods AS (
    SELECT
        "PERIOD" AS BUD_CONTROL_PERIOD_ID,
        DOC      AS PROJECT_ID,
        DOCNO    AS PROJECT_NAME,
        CONMONTH AS BUD_CONTROL_MONTH,
        CONDATE  AS BUD_CONTROL_DATE,
        CASE
        WHEN TRIM(CLOSED) = 'Y' THEN 1
        ELSE 0 END AS IS_CLOSED,
        CURVERSION,
        SOURCE_DB,
        -- התאריך האחרון שבו התקציב היה סגור
        MAX(
            CASE
                WHEN TRIM(CLOSED) = 'Y'
                THEN CONDATE END) OVER (PARTITION BY DOC) AS LATEST_CLOSED_DATE
FROM {{ ref('BUD_CONTROLPERIODS_Z_J') }}
),

final AS (
    SELECT
        *,
        CASE
            WHEN IS_CLOSED = 1 AND CONDATE = LATEST_CLOSED_DATE
            THEN 1 ELSE 0
        END AS IS_LATEST_CLOSED_BUDGET
FROM budget_periods
)

SELECT *
FROM final