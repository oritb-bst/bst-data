with project_planning as ( --פרויקטים >> מהדורות תכנון >> תכנון פרויקטלי
    select *
    from {{ ref('PROJ_PLANNING_V') }}
),

project_versions as ( --מהדורות תכנון
    select *
    from {{ ref('PROJ_BUD_VERSIONS_V') }}
),

income_forecast as ( --אומדן הכנסות
    select *
    from {{ ref('PROJ_BUD_INC_FORECAST_V') }}
),

partial_account as ( --חשבון חלקי מזמין >> חלוקה לסעיפים
    select *
    from {{ ref('MAZMIN_PARTIAL_INVOICES_SECTIONS_V_Budget_Control') }}
),

budget_control as ( --פרויקטים - בקרה תקציבית
    select *
    from {{ ref('PROJ_BUDGET_CONTROL_V') }}
),


-- 1. מסווג כל שורת תכנון למרכיב המתאים באומדן ההכנסות
classified as (
    select
        pp."חברה",
        pp."מספר פרויקט",
        pp."פרויקט_ID",
        pp."מספר מהדורה",
        pv."תאריך מהדורה",
        pv."תיאור מהדורה",
        pv."דגל מהדורת 0",
        pv."דגל ביצוע",
        pp."תכנון פעילות",
        pp."תכנון פרויקט קוד ייחודי",
        pp."מספר פעילות",
        pp."שם פעילות",
        pp."מספר פרק",
        pp."מספר תת פרק",
        pp."תיאור תת פרק",
        pp."מחיר ליחידה",
        pp."עלות ליחידה",
        pp."כמות",
        pp."עלות חומר לפעילות",
        pp."סך הכל מחיר הגשה",
        case
            -- התייקרות על היתרה
            when pp."מספר תת פרק" = '991' then 'התייקרות על היתרה'
            -- קיזוזי מזמין
            when pp."מספר תת פרק" = '993' then 'קיזוז חוזי מזמין' --כולל: קיזוז מזמין, קיזוז מזמין מוסכם, קיזוז ביטוח
            when pp."מספר תת פרק" = '994' then 'קיזוז ידני מזמין' 
            -- בונוס מוסכם ראשי
            when pp."מספר תת פרק" = '97' and coalesce(pp."שם פעילות", '') like '%בונוס מוסכם%' then 'בונוס מוסכם'
            -- חוזה למדידת כמויות
            when try_to_number(pp."מספר תת פרק") not between 90 and 96
                and coalesce(pp."מחיר ליחידה", 0) > 0
                and coalesce(pp."עלות ליחידה", 0) > 0
                and coalesce(pp."שם פעילות", '') not like '%פאושל%'
                then 'חוזה כמויות למדידה'
            -- עבודות נוספות וחריגים
            -- כולל כרגע גם BIM
            when pp."מספר תת פרק" = '99' then 'עבודות נוספות וחריגים'
            -- שירותי קבלן ראשי
            when pp."מספר תת פרק" = '97' and coalesce(pp."שם פעילות", '') like '%שירותי קבלן ראשי%' then 'שירותי קבלן ראשי'
            -- חוזה פאושלי
            when coalesce(pp."שם פעילות", '') like '%פאושל%' then 'חוזה פאושלי'

            else null end as "מרכיבי אומדן הכנסות"
    from project_planning pp

    inner join project_versions pv
        on  pp."חברה" = pv."חברה"
        and pp."מספר פרויקט" = pv."מספר פרויקט"
        and pp."מספר מהדורה" = pv."מספר מהדורה"
),

-- 2. מסכם את תקציב אפס והתקציב המעודכן לפי מרכיב אומדן הכנסות
budget_summary as (
    select
        "חברה",
        "מספר פרויקט",
        "מרכיבי אומדן הכנסות",
        sum(case when "דגל מהדורת 0" = 'Y' then coalesce("סך הכל מחיר הגשה", 0) / 1000.0 else 0 end) as "אפס",
        sum(case when "דגל ביצוע" = 'Y'    then coalesce("סך הכל מחיר הגשה", 0) / 1000.0 else 0 end) as "מעודכן"
    from classified
    where "מרכיבי אומדן הכנסות" is not null
    group by
        "חברה",
        "מספר פרויקט",
        "מרכיבי אומדן הכנסות"
),


-- 3. מיפוי תת פרק -> קטגוריית אומדן הכנסות
-- משתמשים במהדורת הביצוע בלבד, כי אנחנו רוצים את הסיווג הנוכחי של תתי הפרקים.
sub_chapter_mapping as (
    select
        "חברה",
        "מספר פרויקט",
        "מספר תת פרק",
        count(distinct "מרכיבי אומדן הכנסות") as category_count,
        case when count(distinct "מרכיבי אומדן הכנסות") = 1 then max("מרכיבי אומדן הכנסות") else null end as "מרכיבי אומדן הכנסות"
    from classified
    where "דגל ביצוע" = 'Y'
      and "מרכיבי אומדן הכנסות" is not null
    group by
        "חברה",
        "מספר פרויקט",
        "מספר תת פרק"
),

-- 4. שמירה של הבקרה האחרונה בכל חודש לכל פרויקט
income_forecast_by_month as (
    select
        *,
        date_trunc('month', "Date") as "חודש דוח"
    from income_forecast
    qualify dense_rank() over (
        partition by "חברה", "מספר פרויקט", date_trunc('month', "Date")
        order by "Date" desc, "בקרה תקציבית_ID" desc) = 1
),

-- 5. שיוך שורות אומדן ההכנסות לקטגוריות שנקבעו לפי תתי הפרקים
forecast_classified as (
    select
        f."חברה",
        f."מספר פרויקט",
        f."בקרה תקציבית_ID",
        f."Date",
        f."חודש דוח",
        f."מספר תת פרק",
        f."תיאור תת פרק",
        m."מרכיבי אומדן הכנסות",
        m.category_count,
        f."אומדן לגמר (הכנסות) באלפי שח" as "אומדן נוכחי",
        f."אומדן קודם (הכנסות) באלפי שח" as "אומדן קודם"
    from income_forecast_by_month f

    left join sub_chapter_mapping m
        on f."חברה" = m."חברה"
        and f."מספר פרויקט" = m."מספר פרויקט"
        and f."מספר תת פרק" = m."מספר תת פרק"
),


-- 6. סיכום אומדן הנוכחי והקודם לפי חודש וקטגוריית אומדן הכנסות
forecast_summary as (
    select
        "חברה",
        "מספר פרויקט",
        "חודש דוח",
        "מרכיבי אומדן הכנסות",
        sum(coalesce("אומדן נוכחי", 0)) as "אומדן נוכחי",
        sum(coalesce("אומדן קודם", 0)) as "אומדן קודם"
    from forecast_classified
    /*
       category_count = 1 אומר שתת הפרק שייך חד-משמעית
       לקטגוריה אחת.
       אם 97 שייך גם לשירותי קבלן ראשי וגם לבונוס מוסכם,
       הוא לא ייכנס כרגע כדי שלא נכפיל סכומים.
    */
    where category_count = 1
    group by
        "חברה",
        "מספר פרויקט",
        "חודש דוח",
        "מרכיבי אומדן הכנסות"
),


-- 7. יצירת רשימה של כל החודשים שבהם קיימת בקרת אומדן לפרויקט
control_months as (
    select distinct
        "חברה",
        "מספר פרויקט",
        date_trunc('month', "Date") as "חודש בקרה"
    from income_forecast
    where "Date" is not null
),


-- 8. חישוב לכל חודש דוח מהו חודש הבקרה הקודם של אותו פרויקט
report_months as ( 
    select 
        "חברה", 
        "מספר פרויקט", 
        "חודש בקרה" as "חודש דוח", 
        lag("חודש בקרה") over (partition by "חברה", "מספר פרויקט" order by "חודש בקרה") as "חודש דוח קודם" 
    from control_months 
),

-- 9.שומרים את הבקרה האחרונה בכל חודש כדי לדעת מה היתה המהדורה הנוכחית באותו חודש
budget_control_by_month as (
    select
        "חברה",
        "מספר פרויקט",
        "פרויקט_ID",
        "בקרה תקציבית_ID",
        "Date",
        date_trunc('month', "Date") as "חודש דוח",
        "מהדורה נוכחית"
    from budget_control
    where "Date" is not null
    qualify row_number() over (
        partition by
            "חברה",
            "מספר פרויקט",
            date_trunc('month', "Date")
        order by "Date" desc,"בקרה תקציבית_ID" desc) = 1
),

--10. גידול/קיטון בכמויות למדידה - משווים את אותה פעילות בין מהדורה נוכחית למהדורה 0 ורק אם הכמות השתנתה מחשבים את ההפרש
measurement_change_raw as (
    select
        r."חברה",
        r."מספר פרויקט",
        r."חודש דוח",
        bc."מהדורה נוכחית",
        sum(case when coalesce(curr."כמות", 0) <> coalesce(v0."כמות", 0)
                 then coalesce(curr."סך הכל מחיר הגשה", 0) - coalesce(v0."סך הכל מחיר הגשה", 0)
                else 0 end) / 1000.0 as "אומדן נוכחי"
    from report_months r

    left join budget_control_by_month bc
        on  r."חברה" = bc."חברה"
        and r."מספר פרויקט" = bc."מספר פרויקט"
        and r."חודש דוח" = bc."חודש דוח"

    -- מהדורה נוכחית
    left join classified curr
        on  r."חברה" = curr."חברה"
        and r."מספר פרויקט" = curr."מספר פרויקט"
        and curr."מספר מהדורה" = bc."מהדורה נוכחית"

    -- אותה פעילות במהדורה 0
    left join classified v0
        on  curr."חברה" = v0."חברה"
        and curr."מספר פרויקט" = v0."מספר פרויקט"
        and curr."מספר פעילות" = v0."מספר פעילות"
        and v0."דגל מהדורת 0" = 'Y'

    group by
        r."חברה",
        r."מספר פרויקט",
        r."חודש דוח",
        bc."מהדורה נוכחית"
),

--11.מביא את האומדן הקודם מחודש קודם
measurement_change_summary as (
    select
        "חברה",
        "מספר פרויקט",
        "חודש דוח",
        lag("אומדן נוכחי") over (partition by "חברה", "מספר פרויקט"order by "חודש דוח") as "אומדן קודם",
        "אומדן נוכחי"
    from measurement_change_raw
),


--12.שיוך נתוני התקציב לכל אחד מחודשי הדוח של הפרויקט
budget_by_report_month as (
    select
        b."חברה",
        b."מספר פרויקט",
        r."חודש דוח",
        b."מרכיבי אומדן הכנסות",
        b."אפס",
        b."מעודכן"
    from budget_summary b

    inner join report_months r
        on b."חברה" = r."חברה"
        and b."מספר פרויקט" = r."מספר פרויקט"
),


--13.התייקרות בפועל מתוך החשבון החלקי
--רק סעיף "התייקרות מצטברת"
actual_escalation_raw as (
    select
        "חברה",
        "מספר פרויקט",
        "Date" as "תאריך חשבון",
        date_trunc('month', "Date") as "חודש חשבון",
        "סכום מצטבר לפני הנחה" / 1000.0 as "התייקרות בפועל"
    from partial_account
    where trim(coalesce("תיאור סעיף/פרק", '')) = 'התייקרות מצטברת'
      and "Date" is not null
),


--14.שמירת החשבון האחרון בכל חודש עבור ההתייקרות המצטברת
actual_escalation_by_month as (
    select *
    from actual_escalation_raw
    qualify row_number() over (
        partition by
            "חברה",
            "מספר פרויקט",
            "חודש חשבון"
        order by "תאריך חשבון" desc, "התייקרות בפועל" desc) = 1
),


--15.מוצא לכל חודש בקרה את ההתייקרות האחרונה שהייתה ידועה עד אותו חודש
actual_escalation_by_report_month as (
    select
        r."חברה",
        r."מספר פרויקט",
        r."חודש דוח",
        a."התייקרות בפועל"
    from report_months r

    left join actual_escalation_raw a
        on r."חברה" = a."חברה"
        and r."מספר פרויקט" = a."מספר פרויקט"
        -- החשבון האחרון שהיה קיים נכון לחודש הבקרה
        and a."תאריך חשבון" < dateadd(month,1,r."חודש דוח")

    qualify row_number() over (
        partition by
            r."חברה",
            r."מספר פרויקט",
            r."חודש דוח"
        order by a."תאריך חשבון" desc) = 1
),


--16.חישוב התייקרות הנוכחית והקודמת לפי רצף חודשי הבקרה באומדן ההכנסות
actual_escalation_summary as (
    select
        "חברה",
        "מספר פרויקט",
        "חודש דוח",
        "התייקרות בפועל" as "אומדן נוכחי",
        lag("התייקרות בפועל") over (partition by "חברה", "מספר פרויקט" order by "חודש דוח") as "אומדן קודם"
from actual_escalation_by_report_month
),

--17.חיבור בין התקציב לאומדן ומחשב את הערכים הסופיים לכל מרכיב
base_result as (
    select
        b."חברה",
        b."מספר פרויקט",
        b."חודש דוח",
        b."מרכיבי אומדן הכנסות",
        b."אפס",
        b."מעודכן",
        -- בהתייקרות על היתרה מורידים מהאומדן הקודם את ההתייקרות בפועל הקודמת
        case when b."מרכיבי אומדן הכנסות" = 'התייקרות על היתרה'  then coalesce(f."אומדן קודם", 0) - coalesce(a."אומדן קודם", 0)
             when b."מרכיבי אומדן הכנסות" = 'חוזה כמויות למדידה' then coalesce(f."אומדן קודם", 0) - coalesce(m."אומדן קודם", 0)
        else coalesce(f."אומדן קודם", 0) end as "אומדן קודם",
        -- בהתייקרות על היתרה מורידים מהאומדן הנוכחי את ההתייקרות בפועל הנוכחית
        case when b."מרכיבי אומדן הכנסות" = 'התייקרות על היתרה'  then coalesce(f."אומדן נוכחי", 0) - coalesce(a."אומדן נוכחי", 0)
             when b."מרכיבי אומדן הכנסות" = 'חוזה כמויות למדידה' then coalesce(f."אומדן נוכחי", 0) - coalesce(m."אומדן נוכחי", 0)
        else coalesce(f."אומדן נוכחי", 0) end as "אומדן נוכחי",
        -- שינוי = אומדן נוכחי נטו פחות אומדן קודם נטו
        case when b."מרכיבי אומדן הכנסות" = 'התייקרות על היתרה'
                then (coalesce(f."אומדן נוכחי", 0) - coalesce(a."אומדן נוכחי", 0))
                     -
                     (coalesce(f."אומדן קודם", 0) - coalesce(a."אומדן קודם", 0))
             when b."מרכיבי אומדן הכנסות" = 'חוזה כמויות למדידה'
                then (coalesce(f."אומדן נוכחי", 0) - coalesce(m."אומדן נוכחי", 0))
                     -
                     (coalesce(f."אומדן קודם", 0) - coalesce(m."אומדן קודם", 0))
         else coalesce(f."אומדן נוכחי", 0) - coalesce(f."אומדן קודם", 0) end as "שינוי"
    from budget_by_report_month b

    left join forecast_summary f
        on b."חברה" = f."חברה"
        and b."מספר פרויקט" = f."מספר פרויקט"
        and b."חודש דוח" = f."חודש דוח"
        and b."מרכיבי אומדן הכנסות" = f."מרכיבי אומדן הכנסות"

    -- נדרש לצורך הפחתת ההתייקרות בפועל מתוך 991
    left join actual_escalation_summary a
        on b."חברה" = a."חברה"
        and b."מספר פרויקט" = a."מספר פרויקט"
        and b."חודש דוח" = a."חודש דוח"

        -- נדרש לצורך הוספת גידול/קיטון בכמויות לחוזה כמויות למדידה
    left join measurement_change_summary m
        on  b."חברה" = m."חברה"
        and b."מספר פרויקט" = m."מספר פרויקט"
        and b."חודש דוח" = m."חודש דוח"
),

final_result as (
select
    "חברה",
    "מספר פרויקט",
    "חודש דוח",
    "מרכיבי אומדן הכנסות",
    "אפס",
    "מעודכן",
    "אומדן קודם",
    "אומדן נוכחי",
    "שינוי"
from base_result

union all
--התייקרות בפועל
select
    "חברה",
    "מספר פרויקט",
    "חודש דוח",
    'התייקרות בפועל' as "מרכיבי אומדן הכנסות",
    -- להתייקרות בפועל אף פעם אין תקציבים
    0 as "אפס",
    0 as "מעודכן",
    coalesce("אומדן קודם", 0) as "אומדן קודם",
    coalesce("אומדן נוכחי", 0) as "אומדן נוכחי",
    coalesce("אומדן נוכחי", 0) - coalesce("אומדן קודם", 0) as "שינוי"
from actual_escalation_summary

union all
--גידול/קיטון בכמויות למדידה
select
    "חברה",
    "מספר פרויקט",
    "חודש דוח",
    'גידול/קיטון בכמויות למדידה' as "מרכיבי אומדן הכנסות",
    0 as "אפס",
    coalesce("אומדן נוכחי", 0) as "מעודכן", --שווה לאומדן נוכחי
    coalesce("אומדן קודם", 0) as "אומדן קודם",
    coalesce("אומדן נוכחי", 0) as "אומדן נוכחי",
    coalesce("אומדן נוכחי", 0) - coalesce("אומדן קודם", 0) as "שינוי"
from measurement_change_summary
)

select
    "חברה",
    "מספר פרויקט",
    "חודש דוח" as "Date",
    "מרכיבי אומדן הכנסות",
    "אפס",
    "מעודכן",
    "אומדן קודם",
    "אומדן נוכחי",
    "שינוי",
    case
    when "מרכיבי אומדן הכנסות" = 'חוזה כמויות למדידה' then 1
    when "מרכיבי אומדן הכנסות" = 'חוזה פאושלי' then 2
    when "מרכיבי אומדן הכנסות" = 'גידול/קיטון בכמויות למדידה' then 3
    when "מרכיבי אומדן הכנסות" = 'בונוס מוסכם' then 4
    when "מרכיבי אומדן הכנסות" = 'שירותי קבלן ראשי' then 5
    when "מרכיבי אומדן הכנסות" = 'עבודות נוספות וחריגים' then 6
    --when "מרכיבי אומדן הכנסות" = 'קיזוז מזמין מוסכם' then 7
    when "מרכיבי אומדן הכנסות" = 'קיזוז ידני מזמין' then 8
    when "מרכיבי אומדן הכנסות" = 'קיזוז חוזי מזמין' then 9
    --when "מרכיבי אומדן הכנסות" = 'מנהל מודל BIM (50%)' then 10
    --when "מרכיבי אומדן הכנסות" = 'קיזוז ביטוח (1.2%)' then 11
    --when "מרכיבי אומדן הכנסות" = 'קיזוז ביטוח (0.75%)' then 12
    --when "מרכיבי אומדן הכנסות" = 'קיזוז בדיקות מת"י (0.5%)' then 13
    --when "מרכיבי אומדן הכנסות" = 'קיזוז בגין שכירות עגורן' then 14
    when "מרכיבי אומדן הכנסות" = 'התייקרות בפועל' then 15
    when "מרכיבי אומדן הכנסות" = 'התייקרות על היתרה' then 16
    else 99
end as "סדר מיון"
from final_result