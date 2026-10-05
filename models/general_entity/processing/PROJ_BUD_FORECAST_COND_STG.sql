select
    "PERIOD"            as BUD_CONTROL_PERIOD_ID,
    DOC                 as PROJECT_ID,
    DOCNO               as PROJECT_NAME,
    CONDATE             as BUD_CONTROL_DATE,
    -- התייקרויות
    CUSTLINKING         as CUSTOMER_CUMULATIVE_INCREASE,              -- מזמין-התייקרות מצטב'
    LINKING             as CONTRACTOR_CUMULATIVE_INCREASE,            -- קבלן-התייקרות מצטב'
    EFCINCREASERECIEVE  as CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE,   -- התייקרות עתידית לקבל
    EFCINCREASETOPAY    as CONTRACTOR_FORECASTED_INCREASE_TO_PAY,     -- התייקרות עתידית לשלם
    -- קיזוזים
    APPMANREDUCTIONS    as CONTRACTOR_MANUAL_DEDUCTION_ACTUAL,        -- קיזוז ידני - קבלן
    APPCONTREDUCTIONS   as CONTRACTOR_CONTRACTUAL_DEDUCTION_ACTUAL,   -- קיזוז חוזי - קבלן
    BSA_CONTDEDUCTION1  as CONTRACTOR_CONTRACTUAL_DEDUCTION_FUTURE,   -- ק.חוזי עתידי קבלן
    
    CPPCCONTDEDUCTION   as CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED, -- קיזוז חוזי מחש.מזמין
    BSA_CONTDEDUCTIONN  as CUSTOMER_MANUAL_DEDUCTION_FUTURE,          -- ק.ידני עתידי מזמין
    BSA_CONTDEDUCTION   as CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE,     -- ק.חוזי עתידי מזמין
    
    EFCMANREDUCTION     as MANUAL_DEDUCTION_FUTURE,                   -- קיזוז ידני עתידי

    SOURCE_DB
from {{ ref('BUD_FORCASTCONDITION_J') }}