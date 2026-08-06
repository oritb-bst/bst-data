--GUARANTEES
SELECT
	DOCNO           as "מספר פרויקט",
    PROJ_STAT       as "סטטוס פרויקט - אקסל",
    AMOUNT          as "סכום משוערך",
    REDUCTION_VALUE as "הפחתה",
    REDUCTION_NIS   as "הפחתה בש'ח"
FROM {{ source('csv', 'GUARANTEES') }}