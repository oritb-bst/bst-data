--BUD_FORCASTCONDITION
select
	BUD_CONTROL_PERIOD_ID              as "בקרה תקציבית_ID",
	CUST_CUMULATIVE_INCREASE           as "מזמין - התייקרות מצטברת",
	CUST_FORECASTED_INCREASE_TO_RECIVE as "התייקרות עתידית לקבל",
	CONTRACTOR_CUMULATIVE_INCREASE     as "קבלן - התייקרות מצטברת",
	CONTRACTOR_FORECASTED_INCREASE_TO_PAY as "התייקרות עתידית לשלם",
    PROJECT_ID                            as "פרויקט_ID",
	SOURCE_DB                             as "חברה"
from {{ ref('PROJ_BUD_FORECAST_COND') }}