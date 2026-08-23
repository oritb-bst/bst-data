SELECT
    sub.value:PROJACT::NUMBER(13,0)      as PROJACT,
    sub.value:DOC::NUMBER(13,0)          as DOC,
    sub.value:VERSION::NUMBER(3,0)       as VERSION,
    sub.value:PROJACTUID::NUMBER(38,0)   as PROJACTUID,
    sub.value:WBS::STRING                as WBS,
    sub.value:ACTDES::STRING             as ACTDES,
    sub.value:QPRICE::FLOAT              as QPRICE,
    sub.value:MATERIALCOST::FLOAT        as MATERIALCOST,
    SOURCE_DB::STRING                    as SOURCE_DB,
    sub.value:BUD_SUBCHAPTERDES::STRING  as BUD_SUBCHAPTERDES,
    sub.value:BUD_SUBCHAPTERNAME::STRING as BUD_SUBCHAPTERNAME,
    item.value:DOCNO::VARCHAR            as DOCNO, --שדה של האבא
    sub.value:BIDS_ENTRY2::NUMBER(13,0)  as BIDS_ENTRY2,
    sub.value:PRICE::FLOAT               as PRICE,
    sub.value:MED_PROJACTCOST::FLOAT     as MED_PROJACTCOST,

FROM {{ source('json', 'PROJACTS_SUBFORM') }},
LATERAL FLATTEN(INPUT => DATA) item,
LATERAL FLATTEN(INPUT => item.value:PROJACTS_SUBFORM) sub