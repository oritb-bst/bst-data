--מסך נכד חשבון חלקי מזמין >> סכומים מאושרים חשבון חלקי >> חלוקה לסעיפים
select
    SECTION_NUMBER as "מספר סעיף/פרק",
    SECTION_DES    as "תיאור סעיף/פרק",
    CUM_AMOUNT_AFTER_DISCOUNT as "סכום מצטבר אחרי הנחה",
    CUM_AMOUNT_BEFORE_DISCOUNT as "סכום מצטבר לפני הנחה", 
    PROJECT_ID                as "פרויקט_ID",
    PROJECT_NAME              as "מספר פרויקט",
    EXECUTION_DATE            as "Date",
	SOURCE_DB                 as "חברה"
from {{ ref ('MED_APPTRANS_STG') }}