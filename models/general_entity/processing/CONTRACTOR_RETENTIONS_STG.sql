--מסך חשבון חלקי קבלן >> פרטי עכבונות/קיזוזים 
SELECT
    BUD_SUBTOPICNAME as SUB_TOPIC_NAME,
    RETDES           as RET_DES,
    QPRICE_TO        as RET_PRICE,
    CURDATE,
    PROJDOCNO        as PROJECT_NAME,
    DOCNO            as PARTIAL_INVOICE_NAME,
    SOURCE_DB
FROM {{ ref('MED_DOCRETENTION_J') }}