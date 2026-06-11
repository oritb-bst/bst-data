select
    SUP_NAME as "מספר ספק", 
    SUP_DES  as "שם ספק/קבלן",
    SUP_TYPE as "סוג ספק/קבלן",
    SOURCE_DB as "חברה"
from {{ ref('DIM_SUPPLIERS_Buildup') }}