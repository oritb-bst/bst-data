select
    a.value:DOCNO::varchar                           as DOCNO,
    trim(
    regexp_replace(
        regexp_replace(
            regexp_replace(
                regexp_replace(
                    regexp_replace(
                        a.value:MEDR_GUARANTEESTEXT_SUBFORM.TEXT::string,
                        '<style[^>]*>.*?</style>',
                        ' ',
                        1, 0, 'is'
                    ),
                    '<br[[:space:]]*/?>|</p[[:space:]]*>|</div[[:space:]]*>|</li[[:space:]]*>',
                    chr(10),
                    1, 0, 'i'
                ),
                '<[^>]+>',
                ' '
            ),
            '&nbsp;|&#160;',
            ' '
        ),
        '[[:blank:]]+',
        ' '))                                        as TEXT,
    SOURCE_DB::string                                as SOURCE_DB

from {{ source('json', 'MEDR_GUARANTEESTEXT_SUBFORM') }} j,
lateral flatten(input => j.DATA) a