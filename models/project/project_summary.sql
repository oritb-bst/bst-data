{{ config(materialized='table') }}

with forecast as (
    select
        project_doc_no,
        sum(forecast_revenue) as total_forecast_revenue,
        sum(forecast_expense) as total_forecast_expense
    from {{ ref('FORECAST_PROJECTS') }}
    group by project_doc_no
),

invoices as (
    select
        doc_project as project_doc_no,
        sum(total_price) as total_invoiced,
        count(invoice_number) as invoice_count
    from {{ ref('INVOICES') }}
    group by doc_project
)

select
    f.project_doc_no,
    f.total_forecast_revenue,
    f.total_forecast_expense,
    i.total_invoiced,
    i.invoice_count
from forecast f
left join invoices i
    on f.project_doc_no = i.project_doc_no