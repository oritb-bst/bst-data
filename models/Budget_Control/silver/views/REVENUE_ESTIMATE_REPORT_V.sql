with project_planning as (
    select *
    from {{ ref('PROJ_PLANNING_V') }}
),

project_versions as (
    select *
    from {{ ref('PROJ_BUD_VERSIONS_V') }}
),

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
        pp."עלות חומר לפעילות",
        pp."סך הכל מחיר הגשה",
        case
            -- קיזוזי מזמין
            -- כולל: קיזוז מזמין, קיזוז מזמין מוסכם, קיזוז ביטוח
            when pp."מספר תת פרק" = '994' then 'קיזוזי מזמין'
            -- עבודות נוספות וחריגים
            -- כולל כרגע גם BIM
            when pp."מספר תת פרק" = '99' then 'עבודות נוספות וחריגים'
            -- שירותי קבלן ראשי
            when pp."מספר תת פרק" = '97' and coalesce(pp."שם פעילות", '') like '%שירותי קבלן ראשי%' then 'שירותי קבלן ראשי'
            -- בונוס מוסכם ראשי
            when pp."מספר תת פרק" = '97' and coalesce(pp."שם פעילות", '') like '%בונוס מוסכם%' then 'בונוס מוסכם ראשי'
            -- חוזה פאושלי
            when coalesce(pp."שם פעילות", '') like '%פאושל%' then 'חוזה פאושלי'
            -- חוזה למדידת כמויות
            when pp."מספר פרק" not between 60 and 90
                and coalesce(pp."מחיר ליחידה", 0) > 0
                and coalesce(pp."עלות ליחידה", 0) > 0
                and coalesce(pp."שם פעילות", '') not like '%פאושל%'
                then 'חוזה למדידת כמויות'
            else null end as "מרכיבי אומדן הכנסות"
    from project_planning pp

    inner join project_versions pv
        on  pp."חברה" = pv."חברה"
        and pp."פרויקט_ID" = pv."פרויקט_ID"
        and pp."מספר מהדורה" = pv."מספר מהדורה"
)

select
    *,
    -- תקציב אפס
    case when "דגל מהדורת 0" = 1 then coalesce("סך הכל מחיר הגשה", 0) else 0 end as "אפס",
    -- תקציב מעודכן
    case when "דגל ביצוע" = 1 then coalesce("סך הכל מחיר הגשה", 0) else 0 end as "מעודכן"
from classified