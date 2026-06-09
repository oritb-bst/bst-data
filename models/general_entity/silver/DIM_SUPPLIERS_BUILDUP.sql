select
    SUP_NAME, 
    SUP_DES,
    SUP_TYPE,
    SOURCE_DB
from {{ ref('DIM_SUPPLIERS_BUILDUP_STG') }}