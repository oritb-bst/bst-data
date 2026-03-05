SELECT
   *
FROM {{ source('csv', 'WORK_PLAN') }}