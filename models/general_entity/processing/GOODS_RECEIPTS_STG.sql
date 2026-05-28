--DOCUMENTS_P
select
    PROJDOCNO as PROJECT_NAME,
    SUPNAME   as SUP_NAME,
    CURDATE,
    DISPRICE  as PRICE_AFTER_DIS_GR,
    STATDES   as STATUS_GR,
    DOCNO     as DOCUMENT_NAME,
    SOURCE_DB
from {{ ref('DOCUMENTS_P_J') }}
--FROM {{ source('bronze', 'DOCUMENTS_P') }}