-- פיתוח של הזמנות עם קבלות סחורה + הזמנות ללא
with goods_receipts as ( -- קבלות סחורה
    select *,
           row_number() over (partition by
                "מספר פרויקט",
                "חברה",
                "מספר ספק",
                "מספר הזמנת רכש"
            order by "Date", "מספר קבלת סחורה") as rn
    from {{ ref('GOODS_RECEIPTS_V_Budget_Control') }}
),

purchase_orders as ( -- הזמנות רכש
    select *
    from {{ ref('PURCHASE_ORDERS_V_Budget_Control') }}
),

-- קבלות סחורה עם נתוני ההזמנה
receipts_with_orders as (
    select
        gr."מספר פרויקט",
        gr."מספר ספק",
        gr."Date",
        gr."חברה",
        gr."מספר הזמנת רכש",
        gr."מספר קבלת סחורה",
        gr."מחיר קבלת סחורה מספק אחרי הנחה",
        gr."סטטוס קבלת סחורה מספק",
        gr."דגל קבלת סחורה חויבה",
        case when gr.rn = 1 then po."מחיר הזמנת רכש אחרי הנחה" end as "מחיר הזמנת רכש אחרי הנחה",
        po."סטטוס הזמנת רכש"
    from goods_receipts gr

    left join purchase_orders po
        on gr."מספר פרויקט" = po."מספר פרויקט"
        and gr."חברה" = po."חברה"
        and gr."מספר ספק" = po."מספר ספק"
        and gr."מספר הזמנת רכש" = po."מספר הזמנת רכש"
),

-- הזמנות רכש שאין להן קבלות סחורה
orders_without_receipts as (
    select
        po."מספר פרויקט",
        po."מספר ספק",
        po."Date",
        po."חברה",
        po."מספר הזמנת רכש",
        null as "מספר קבלת סחורה",
        null as "מחיר קבלת סחורה מספק אחרי הנחה",
        null as "סטטוס קבלת סחורה מספק",
        null as "דגל קבלת סחורה חויבה",
        po."מחיר הזמנת רכש אחרי הנחה",
        po."סטטוס הזמנת רכש"
    from purchase_orders po

    where not exists (
        select 1
        from goods_receipts gr
        where gr."מספר פרויקט" = po."מספר פרויקט"
          and gr."חברה" = po."חברה"
          and gr."מספר ספק" = po."מספר ספק"
          and gr."מספר הזמנת רכש" = po."מספר הזמנת רכש"
    )
)

select * from receipts_with_orders

union all

select * from orders_without_receipts
