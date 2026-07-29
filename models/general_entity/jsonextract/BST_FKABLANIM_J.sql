SELECT
    sub.value:FORECAST::string     AS FORECAST,
    sub.value:ORDNAME::STRING            AS ORDNAME,
    sub.value:SUPNAME::STRING            AS SUPNAME,
    sub.value:SUPDES::STRING             AS SUPDES,
    sub.value:DETAILS::STRING            AS DETAILS,
    sub.value:BOOKNUM::STRING            AS BOOKNUM,
    sub.value:STATDES::STRING            AS STATDES,
    sub.value:QPRICE::FLOAT              AS QPRICE,
    sub.value:PREVALUE::FLOAT            AS PREVALUE,
    sub.value:PAYDATE::DATE              AS PAYDATE,
    item.value:FOREX::STRING             AS FOREX,
    sub.value:FKABLANIM::STRING          AS FKABLANIM,
    SOURCE_DB::STRING                    AS SOURCE_DB

FROM {{ source('json', 'BST_FKABLANIM_SUBFORM') }},
LATERAL FLATTEN(input => DATA) item,
LATERAL FLATTEN(input => item.value:BST_FKABLANIM_SUBFORM) sub