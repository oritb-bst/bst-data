{% macro generate_schema_name(custom_schema_name=none, node=none) -%}
    {%- set target_name = target.name -%}
    {%- set file_path = node.original_file_path | lower -%}

    {% if target_name == 'dev' %}
        {{ target.schema }}
    {% else %}
        {% if 'ready' in file_path %}
            READY
        {% elif 'processing' in file_path %}
            PROCESSING
        {% else %}
            MAIN
        {% endif %}
    {% endif %}
{%- endmacro %}