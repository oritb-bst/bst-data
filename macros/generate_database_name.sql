{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set target_db = target.database | upper -%}
    {%- set target_name = target.name | lower -%}
    {%- set file_path = node.path | lower -%}

    {# בדיקה אם אנחנו בסביבת UAT #}
    {% if 'UAT' in target_db or target_name == 'uat' %}

        {% if 'silver' in file_path or 'cashflow' in file_path %}
            SILVER_UAT
        {% elif 'gold' in file_path %}
            GOLD_UAT
        {% elif 'bronze' in file_path or 'jsonextract' in file_path %}
            BRONZE_UAT
        {% elif 'processing' in file_path or 'ready' in file_path %}
            STAGING_UAT
        {% else %}
            {{ target.database }}
        {% endif %}

    {# במידה ולא UAT - סביבת PROD #}
    {% else %}

        {% if 'silver' in file_path or 'cashflow' in file_path %}
            SILVER_PROD
        {% elif 'gold' in file_path %}
            GOLD_PROD
        {% elif 'bronze' in file_path or 'jsonextract' in file_path %}
            BRONZE_PROD
        {% elif 'processing' in file_path or 'ready' in file_path %}
            STAGING_PROD
        {% else %}
            {{ target.database }}
        {% endif %}

    {% endif %}

{%- endmacro %}