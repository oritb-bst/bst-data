--צפי חוזה קבלן
select
    SUP_NAME                 as "מספר ספק",
    SUB_TOPIC_NAME           as "מספר משאב",
    ORIGINAL_CONTRACT_AMOUNT as "היקף חוזה מקורי",
    UPDATED_CONTRACT_AMOUNT  as "היקף חוזה מעודכן",
    CUMULATIVE_ACCOUNT as "חשבון מצטבר",
    AMOUNT_INCREASE    as "סכום התייקרות",
    BUD_CONTROL_DATE   as "Date",
    PROJECT_NAME       as "מספר פרויקט",
	t.SOURCE_DB          as "חברה"
from {{ ref ('BUD_CONTFORECAST_STG') }} t

{{ join_bst_projects_budget_control('PROJECT_NAME', 't.SOURCE_DB') }}