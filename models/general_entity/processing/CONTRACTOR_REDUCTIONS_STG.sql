--איחוד של 2 טבלאות
--שני מסכי נכד של פרויקטים-בקרה תקציבית >> תנאים מיוחדים >> מאושר-קיזוז חוזי-תעודות + מאושר-קיזוז ידני-תעודות
with CONTRACT_REDUCTIONS as ( --קיזוז חוזי
    select
        DOCNO   as PROJECT_NAME,
        CONDATE as BUD_CONTROL_DATE,
        DOCCODE,
        SUPNAME as SUP_NAME,
        APPCONTREDUCTIONS as CONTRACT_REDUCTION,
        0                 as MANUAL_REDUCTION,
        SOURCE_DB
    from {{ ref('BUD_APPCONTREDUCTD_J') }}
),

MANUAL_REDUCTIONS as ( --קיזוז ידני
    select
        DOCNO   as PROJECT_NAME,
        CONDATE as BUD_CONTROL_DATE,
        DOCCODE,
        SUPNAME as SUP_NAME, 
        0                as CONTRACT_REDUCTION,
        APPMANREDUCTIONS as MANUAL_REDUCTION,
        SOURCE_DB
    from {{ ref('BUD_APPMANREDUCTIOND_J') }}
),

COMBINED as (
    select * from CONTRACT_REDUCTIONS
    union all
    select * from MANUAL_REDUCTIONS
)

select
    PROJECT_NAME,                               
    BUD_CONTROL_DATE,
    DOCCODE,
    MAX(SUP_NAME) as SUP_NAME,
    SUM(COALESCE(CONTRACT_REDUCTION, 0)) as CONTRACT_REDUCTION,
    SUM(COALESCE(MANUAL_REDUCTION, 0))   as MANUAL_REDUCTION,
    SOURCE_DB
from COMBINED
group by
    PROJECT_NAME,
    BUD_CONTROL_DATE,
    DOCCODE,
    SUP_NAME,
    SOURCE_DB
