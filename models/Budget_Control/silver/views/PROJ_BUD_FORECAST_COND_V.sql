--BUD_FORCASTCONDITION
select
	BUD_CONTROL_PERIOD_ID              as "בקרה תקציבית_ID",
    PROJECT_ID                         as "פרויקט_ID",
    PROJECT_NAME                       as "מספר פרויקט",
    BUD_CONTROL_DATE                   as "Date",
    -- התייקרויות
	CUSTOMER_CUMULATIVE_INCREASE            as "מזמין-התייקרות מצטב'",
	CONTRACTOR_CUMULATIVE_INCREASE          as "קבלן-התייקרות מצטב'",
	CUSTOMER_FORECASTED_INCREASE_TO_RECEIVE as "התייקרות עתידית לקבל",
	CONTRACTOR_FORECASTED_INCREASE_TO_PAY   as "התייקרות עתידית לשלם",
    --קיזוזים
    CONTRACTOR_MANUAL_DEDUCTION_ACTUAL      as "קיזוז ידני - קבלן",
    CONTRACTOR_CONTRACTUAL_DEDUCTION_ACTUAL as "קיזוז חוזי - קבלן",
    CONTRACTOR_CONTRACTUAL_DEDUCTION_FUTURE as "ק.חוזי עתידי קבלן",

    CUSTOMER_CONTRACTUAL_DEDUCTION_CALCULATED as "קיזוז חוזי מחש.מזמין",
    CUSTOMER_MANUAL_DEDUCTION_FUTURE          as "ק.ידני עתידי מזמין",
    CUSTOMER_CONTRACTUAL_DEDUCTION_FUTURE     as "ק.חוזי עתידי מזמין",
	
    MANUAL_DEDUCTION_FUTURE                   as "קיזוז ידני עתידי",
    t.SOURCE_DB                               as "חברה"
from {{ ref('PROJ_BUD_FORECAST_COND_STG') }} t

{{ join_bst_projects_budget_control('PROJECT_NAME', 't.SOURCE_DB') }}