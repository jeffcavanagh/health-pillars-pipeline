{% macro sum_or_null(column1, column2) %}
    case
        when {{ column1 }} is null and {{ column2 }} is null then null
        else coalesce({{ column1 }}, 0) + coalesce({{ column2 }}, 0)
    end
{% endmacro %}