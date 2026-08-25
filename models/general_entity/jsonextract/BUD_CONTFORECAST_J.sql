--צפי חוזה קבלן
SELECT
    sub.value:ORIGCONTSUM::FLOAT   AS ORIGCONTSUM,
    sub.value:UPDACONTSUM::FLOAT   AS UPDACONTSUM,
    sub.value:ACCUMSUM::FLOAT      AS ACCUMSUM,
    sub.value:PRICEINCREASE::FLOAT AS PRICEINCREASE,
    item.value:CONDATE::date       AS CONDATE, --שדה של האבא
    item.value:DOCNO::VARCHAR      AS DOCNO, --שדה של האבא
    SOURCE_DB::STRING              AS SOURCE_DB

FROM {{ source('json', 'BUD_CONTFORECAST_SUBFORM') }},
LATERAL FLATTEN(input => DATA) item,
LATERAL FLATTEN(input => item.value:BUD_CONTFORECAST_SUBFORM) sub