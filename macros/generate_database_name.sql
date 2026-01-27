target. Database {% macro generate_database_name(custom_database_name=none, node=none) -%}
 
  {%- set target_name = target.name -%}
 
  {% if target_name == 'DEV' %}
      DEVELOPMENT
  {% elif target_name == 'UAT' %}
     {# Non-dev, non-ci environments use folder-based database logic #}
      {% set file_path = node.original_file_path %}
      {% if 'silver' in file_path  %}
          SILVER_UAT
      {% elif 'gold' in file_path  %}   
          GOLD_UAT
      {% elif 'datalake' in file_path  %}
          BRONZE_UAT
      {% else %}
          {{target.database}} {# Default fallback to target database #}
      {% endif %}
  {% else %}
      {# Non-dev, non-ci environments use folder-based database logic #}
      {% set file_path = node.original_file_path %}
      {% if 'silver' in file_path  %}
          SILVER_PROD
      {% elif 'gold' in file_path  %}
          GOLD_PROD
      {% elif 'datalake' in file_path  %}
          BRONZE_PROD
      {% else %}
          {{target.database}} {# Default fallback to target database #}
      {% endif %}
  {% endif %}
{% endmacro %}