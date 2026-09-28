{% macro show_target() %}
    {{ log("TARGET NAME = " ~ target.name, info=True) }}
    {{ log("TARGET DATABASE = " ~ target.database, info=True) }}
    {{ log("TARGET SCHEMA = " ~ target.schema, info=True) }}
{% endmacro %}