select
    DOC         as PROJECT_ID,
    "VERSION"   as VERSION_ID,
    CURDATE     as VER_DATE,
	TEXT        as VER_DES,
	BUD_ZERO    as IS_ZERO_EDITION,
	BUD_EXECUTE as IS_EXECUTED,  
	SOURCE_DB
from {{ ref ('PROJVERSIONS_J') }}