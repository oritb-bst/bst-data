SELECT
   PROJECT_NAME,
   PROJECT_NUMBER,
    TO_CHAR(
        DATE_FROM_PARTS(
            2000 + TO_NUMBER(RIGHT(WORK_PLAN.MONTH_WORK_PLAN,2)),  -- שנה
            TO_NUMBER(LEFT(WORK_PLAN.MONTH_WORK_PLAN,2)),          -- חודש
            1                                                      -- יום
        ),
        'DD/MM/YYYY'
   )  ::DATE AS MONTH_WORK_PLAN,
   REVENUE,
   EXPENSE
FROM {{ source('csv', 'WORK_PLAN') }}