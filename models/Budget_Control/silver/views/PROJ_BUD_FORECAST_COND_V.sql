--BUD_FORCASTCONDITION
select
	BUD_CONTROL_PERIOD_ID              as "תקופה לבקרה",
	CUST_CUMULATIVE_INCREASE           as "מזמין - התייקרות מצטברת",
	CUST_FORECASTED_INCREASE_TO_RECIVE as "התייקרות עתידית לקבל",
	CONTRACTOR_CUMULATIVE_INCREASE     as "קבלן - התייקרות מצטברת",
	CONTRACTOR_FORECASTED_INCREASE_TO_PAY as "התייקרות עתידית לשלם",
	SOURCE_DB                             as "חברה"
from {{ ref('PROJ_BUD_FORECAST_COND') }}