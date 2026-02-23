{% macro generate_schema_name (custom_schema_name=none, node=none) -%}

    {%- set target_name = target.name -%}

    {% if target_name == 'dev' %}
        {# Use the profile name to create a developer-specific schema #}
        {{target.schema}}
    {% else %}
        {% set file_path = node.original_file_path %}
        {% if 'ready' in file_path %}
            READY
        {% elif 'processing' in file_path  %}
            PROCESSING
        {% else %}
            MAIN
        {% endif %}
    {% endif %}
{% endmacro %}