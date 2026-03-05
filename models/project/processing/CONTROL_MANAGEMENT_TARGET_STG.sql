SELECT
   *
FROM {{ source('csv', 'CONTROL_MANAGEMENT_TARGET') }}