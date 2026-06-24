-- סינון על 4 השנים האחרונות כולל שנה נוכחית

{% macro filter_last_n_years(date_field, years=3) %}
    {{ date_field }} >= {{ dbt.dateadd(
        datepart="year",
        interval=-years,
        from_date_or_timestamp=dbt.current_timestamp()
    ) }}
{% endmacro %}