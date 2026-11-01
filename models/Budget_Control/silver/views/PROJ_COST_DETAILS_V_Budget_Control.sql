--BUD_PROJSECTCOSTC_SUBFORM
SELECT
    PROJECT_NAME     as "מספר פרויקט",
    BUD_CONTROL_DATE as "Date",
    UNIT_OF_MEASURE  as "יחידת מידה",
    QUANTITY         as "כמות",
    UNIT_COST        as "עלות ליחידה",
    TOTAL_COST       as "סך הכל עלות",
    coalesce(SUB_CHAPTER_NAME, 'ללא') as "מספר תת פרק",
	SUB_TOPIC_NAME   as "מספר משאב",
    SOURCE_DB        as "חברה"
FROM {{ ref('PROJ_COST_DETAILS_STG') }}