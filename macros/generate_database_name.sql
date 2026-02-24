{% macro generate_database_name(custom_database_name=none, node=none) -%}
    {%- set target_name = target.name -%}
    {%- set file_path = node.original_file_path | lower -%}

    {% if target_name == 'dev' %}
        DEVELOPMENT

    {% elif target_name == 'UAT' %}
        {% if 'silver' in file_path %}
            SILVER_UAT
        {% elif 'gold' in file_path %}
            GOLD_UAT
        {% elif 'bronze' in file_path %}
            BRONZE_UAT
        {% else %}
            {{ target.database }}
        {% endif %}

    {% else %}
        {% if 'silver' in file_path %}
            SILVER_PROD
        {% elif 'gold' in file_path %}
            GOLD_PROD
        {% elif 'bronze' in file_path %}
            BRONZE_PROD
        {% else %}
            {{ target.database }}
        {% endif %}
    {% endif %}
{%- endmacro %}