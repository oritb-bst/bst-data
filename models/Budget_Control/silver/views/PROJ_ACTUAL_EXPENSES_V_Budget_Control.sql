with resource_categories as ( --זיהוי קטגוריית המשאב (בטון, ברזל או משאבות) לפי נתוני התקציב
    select
        "מספר פרויקט",
        "חברה",
        "מספר תת פרק",
        "מספר משאב",
        max(case when "מספר משאב" in ('402150', '402100') then 'משאבות'
                 when "מספר נושא" = '013' then 'בטון'
                 when "מספר נושא" = '265' then 'ברזל'
                 else null end) as "קטגוריית משאב לגרף"
    from {{ ref('PROJ_BUD_EXP_FORECAST_V') }}
    group by 1, 2, 3, 4
),

actual_base as (
    select
        a.source_db as "חברה",
        Control_Date as "Date",
        Project as "מספר פרויקט",
        Project_Desc as "תיאור פרויקט",
        Sub_Chapter as "מספר תת פרק",
        Sub_Chapter_Desc as "תיאור תת פרק",
        Resource as "מספר משאב",
        Resource_Desc as "תיאור משאב",
        Doc_Type as "סוג תעודה",
        Doc_Desc as "תיאור תעודה",
        Supplier_No as "מספר ספק",
        Supplier_Name as "שם ספק",
        Doc_No as "מספר תעודה",
        case when Doc_No like 'PO%' then Doc_No end as "מספר הזמנת רכש",
        case when Doc_No like 'GR%' then Doc_No end as "מספר קבלת סחורה",
        Exec_Month_Date as "תאריך/חודש ביצוע",
        Part_No as "מק'ט",
        Part_Desc as "תיאור מוצר",
        Doc_Quant as "כמות בתעודה",
        Factory_Unit as "יח' מפעל",
        Unit_Price as "מחיר יח'",
        Amount as "סכום",
        Expense_Type as "סוג הוצאה",
        Project_Expenses_Exclude_Flag,
        Control_Month,
        Entity_Name
    from {{ ref('PROJECT_ACTUAL_EXPENSES_STG') }} a

    {{ join_valid_projects('a.Project', 'a.source_db') }}
),

actual_classified as ( --סיווג שורות בטון וברזל ל"רגיל" או "שונות" לפי יחידת המידה ותיאור המוצר
    select
        a.*,
        d."קטגוריית משאב לגרף",
        case when d."קטגוריית משאב לגרף" = 'בטון' and a."יח' מפעל" is distinct from 'קוב' then 'שונות'
             when d."קטגוריית משאב לגרף" = 'ברזל' and (
                    a."יח' מפעל" is distinct from 'טון'
                    or a."תיאור מוצר" ilike '%כיפוף%'
                    or a."תיאור מוצר" ilike '%חיתוך%'
                    or a."תיאור מוצר" ilike '%הרכבת אלמנט%'
                    or a."תיאור מוצר" ilike '%תוספת%')
                then 'שונות' else 'רגיל' end as "סוג שורת ביצוע לגרף"
    from actual_base a

    left join resource_categories d
        on a."מספר פרויקט" = d."מספר פרויקט"
       and a."חברה" = d."חברה"
       and a."מספר תת פרק" = d."מספר תת פרק"
       and a."מספר משאב" = d."מספר משאב"
)

--חישוב כמות לגרף ללא חריגים ותוספות, וסכום לגרף הכולל גם עלויות שונות
select
    *,
    -- כמות: רק בטון בקוב או ברזל רגיל בטון, ללא תוספות
    case
        when "קטגוריית משאב לגרף" in ('בטון', 'ברזל')
         and "סוג שורת ביצוע לגרף" = 'רגיל'
         and "מספר משאב" not in (
             '102190', '102191', '102195', '102290')
        then coalesce("כמות בתעודה", 0)
        else 0 end as "כמות לגרף",
    -- סכום: כולל גם שונות ותוספות
    case when "קטגוריית משאב לגרף" in ('בטון', 'ברזל') then coalesce("סכום", 0) else 0 end as "סכום לגרף"
from actual_classified
