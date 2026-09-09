-- חוזה מזמין 
with contracts as ( 
    select 
        "מספר פרויקט", 
        "מספר לקוח", 
        "תנאי תשלום", 
        "סוג חוזה מזמין", 
        "מחיר כולל מעמ באלפי שח", 
        "Date", 
        "סטטוס חוזה מזמין", 
        "חברה" 
    from {{ ref('MAZMIN_CONTRACTS_V_Budget_Control') }} 
 
    where "סוג חוזה מזמין" = 'CO' 
      and coalesce("מחיר כולל מעמ באלפי שח", 0) > 0 
), 
 
-- הצמדה לחוזה + תיאור מטבע
contract_escalation as ( 
    select 
        e."מספר פרויקט", 
        e."מטבע",
        c."תיאור מטבע" as "סוג הצמדה",
        e."תאריך תחילת הצמדה", 
        date_trunc('month', e."תאריך תחילת הצמדה") as "חודש בסיס", 
        e."שער בסיס" as "מדד בסיס", 
        e."חברה" 
    from {{ ref('MAZMIN_CONTRACT_ESCALATION_V_Budget_Control') }} e

    left join {{ ref('DIM_CURRENCIES_V_Budget_Control') }} c
        on e."מטבע" = c."מטבע"
       and e."חברה" = c."חברה"
), 

-- חודש נוכחי - חודש הביצוע האחרון מחשבון חלקי מזמין בסטטוס סופית
current_execution_month as (
    select
        "מספר פרויקט",
        "חברה",
        date_trunc('month', "Date") as "חודש נוכחי"
    from {{ ref('MED_DOCUMENTS_D_V_Budget_Control') }}
    where "סטטוס חשבון חלקי מזמין" = 'סופית'
      and "Date" is not null

    qualify row_number() over (partition by "מספר פרויקט","חברה" order by "Date" desc) = 1
),

 
-- בסיס הדוח 
report_base as (
    select
        c."מספר פרויקט",
        c."מספר לקוח",
        c."חברה",
        e."מטבע",
        e."סוג הצמדה",
        e."תאריך תחילת הצמדה",
        e."חודש בסיס",
        e."מדד בסיס",
        m."חודש נוכחי",
        c."תנאי תשלום"
    from contracts c

    left join contract_escalation e
        on c."מספר פרויקט" = e."מספר פרויקט"
       and c."חברה" = e."חברה"

    left join current_execution_month m
        on c."מספר פרויקט" = m."מספר פרויקט"
       and c."חברה" = m."חברה"
)
 
select
    "מספר פרויקט",
    "מספר לקוח",
    "חברה",
    "מטבע",
    "סוג הצמדה",
    "תאריך תחילת הצמדה",
    "חודש בסיס",
    "מדד בסיס",
    "חודש נוכחי",
    "תנאי תשלום"
from report_base