select
    a.value:DOCNO::varchar                           as DOCNO,
    trim(
        regexp_replace(
            regexp_replace(
                regexp_replace(
                    regexp_replace(
                        a.value:MEDR_GUARANTEESTEXT_SUBFORM.TEXT::string,
                        '<style[^>]*>.*?</style>',
                        ' ',
                        1, 0, 'is'
                    ),
                    '<[^>]+>',
                    ' '
                ),
                '&[a-zA-Z0-9#]+;',
                ' '
            ),
            '\\s+',
            ' '
        )
    )                                                as TEXT,
    SOURCE_DB::string                                as SOURCE_DB

from {{ source('json', 'MEDR_GUARANTEESTEXT_SUBFORM') }} j,
lateral flatten(input => j.DATA) a