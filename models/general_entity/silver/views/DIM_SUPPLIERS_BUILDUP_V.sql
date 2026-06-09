select
    SUP_NAME as "מספר ספק/קבלן", 
    SUP_DES  as "שם ספק/קבלן",
    SUP_TYPE as "סוג ספק/קבלן",
    SOURCE_DB as "חברה"
from {{ ref('DIM_SUPPLIERS_BUILDUP') }}