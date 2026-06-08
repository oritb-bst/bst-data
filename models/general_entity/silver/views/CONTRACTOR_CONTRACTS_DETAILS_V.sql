--MED_PORDERITEMS_SUBFORM
SELECT
	CONTRACT_SECTION_NAME as "מספר סעיף חוזה",
    CONTRACT_SECTION_DES  as "תיאור סעיף חוזה",
    QUANTITY              as "כמות",
    NET_UNIT_PRICE        as "מחיר ליח' נטו",
    TOTAL_PRICE           as "סך הכל מחיר",
    PORD_ID               as "חוזה_ID",
	SOURCE_DB             as "חברה"
FROM {{ ref('CONTRACTOR_CONTRACTS_DETAILS') }}