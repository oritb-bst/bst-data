SELECT
   *
FROM {{ source('csv', 'EXPENSES') }}
