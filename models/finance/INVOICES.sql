select *
from {{ source('bronze', 'INVOICES') }}