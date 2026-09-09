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
        c."תנאי תשלום" 
    from contracts c 
 
    left join contract_escalation e 
        on c."מספר פרויקט" = e."מספר פרויקט" 
       and c."חברה" = e."חברה" 
) 
 
select 
    "מספר פרויקט", 
    "מספר לקוח", 
    "חברה", 
    "סוג הצמדה", 
    "תאריך תחילת הצמדה", 
    "חודש בסיס", 
    "מדד בסיס", 
    "תנאי תשלום" 
from report_base