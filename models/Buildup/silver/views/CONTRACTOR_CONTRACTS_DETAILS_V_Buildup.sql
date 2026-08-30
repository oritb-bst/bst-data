--MED_PORDERITEMS_SUBFORM
SELECT
	CONTRACT_SECTION_NAME as "מספר סעיף חוזה",
    CONTRACT_SECTION_DES  as "תיאור סעיף חוזה",
    QUANTITY              as "כמות",
    NET_UNIT_PRICE        as "מחיר ליח' נטו",
    TOTAL_PRICE           as "סך הכל מחיר",
    PORD_ID               as "חוזה_ID",
    CUMULATIVE_AMOUNT     as "סכום מצטבר",
    SUB_TOPIC_NAME        as "מספר משאב",
    SUB_TOPIC_DES         as "תיאור משאב",
	SOURCE_DB             as "חברה"
FROM {{ ref('CONTRACTOR_CONTRACTS_DETAILS_STG') }}
WHERE SOURCE_DB='BLDUP'