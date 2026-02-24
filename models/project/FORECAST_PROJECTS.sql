select *
from {{ source('bronze', 'FORECAST_PROJECTS') }}