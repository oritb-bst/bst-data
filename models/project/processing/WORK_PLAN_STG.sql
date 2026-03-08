SELECT
   PROJECT_NAME,
   PROJECT_NUMBER,
   TO_CHAR(
        DATE_FROM_PARTS(
            YEAR(CURRENT_DATE()),
            MONTH(MONTH_WORK_PLAN),
            1
        ),
        'MM/YY'
   ) AS MONTH_YEAR,
	REVENUE,
	EXPENSE
FROM {{ source('csv', 'WORK_PLAN') }}