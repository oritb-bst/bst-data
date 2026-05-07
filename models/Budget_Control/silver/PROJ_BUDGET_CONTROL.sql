select 
    "PERIOD",
    PROJECT_ID,
    "MONTH",
    DATE,
    CURVERSION,
    SOURCE_DB
from {{ ref('PROJ_BUDGET_CONTROL_STG') }}