
{{ config(materialized='table') }}

select
    IVNUM as invoice_number,
    DOC_PROJECT as doc_project,
    IVDATE as invoice_date,
    TOTPRICE as total_price
from {{ source('bronze', 'INVOICES') }}