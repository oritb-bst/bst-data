SELECT
    SUP     as SUP_ID,
	SUPNAME as SUP_NAME,
	SUPDES  as SUP_DES,
	SOURCE_DB
FROM {{ source('bronze', 'SUPPLIERS') }}