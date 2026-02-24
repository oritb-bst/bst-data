{% macro get_current_user() %}
{% set results = run_query("SELECT CURRENT_USER()") %}
{% if execute %}
{{ return(results.columns[0].values()[0]) }}
{% else %}
{{ return("default_user") }}
{% endif %}
{% endmacro %}