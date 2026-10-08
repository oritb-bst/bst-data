{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set target_name = target.name | lower | trim -%}
    {%- set file_path = node.path | lower -%}

    {%- if target_name == 'dev' -%}
        DEVELOPMENT
    {%- elif target_name == 'uat' -%}
        {%- if 'silver' in file_path -%}
            SILVER_UAT
        {%- elif 'gold' in file_path -%}
            GOLD_UAT
        {%- elif 'jsonextract' in file_path or 'bronze' in file_path -%}
            BRONZE_UAT
        {%- elif 'processing' in file_path or 'ready' in file_path -%}
            STAGING_UAT
        {%- else -%}
            {{ target.database }}
        {%- endif -%}
    {%- else -%}
        {%- if 'silver' in file_path -%}
            SILVER_PROD
        {%- elif 'gold' in file_path -%}
            GOLD_PROD
        {%- elif 'jsonextract' in file_path or 'bronze' in file_path -%}
            BRONZE_PROD
        {%- elif 'processing' in file_path or 'ready' in file_path -%}
            STAGING_PROD
        {%- else -%}
            {{ target.database }}
        {%- endif -%}
    {%- endif -%}

{%- endmacro %}