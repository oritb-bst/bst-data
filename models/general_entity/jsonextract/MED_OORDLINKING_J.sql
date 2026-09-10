--מסך בן של חוזים מזמין - הצמדה לחוזה
select
    item.value:DOCNO::string   as DOCNO, --שדה של האבא
    item.value:ORDNAME::string as ORDNAME, --שדה של האבא
    sub.value:CODE::string     as CODE,
    sub.value:STARTDATE::date  as STARTDATE,
    sub.value:BASEVALUE::float as BASEVALUE,
    SOURCE_DB::string          as SOURCE_DB

FROM {{ source('json', 'MED_OORDLINKING_SUBFORM') }},
LATERAL FLATTEN(input => DATA) item,
LATERAL FLATTEN(input => item.value:MED_OORDLINKING_SUBFORM) sub