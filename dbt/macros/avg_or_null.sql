{% macro avg_or_null(column1, column2) %}
    case
        when {{ column1 }} is not null and {{ column2 }} is not null then ({{ column1 }} + {{ column2 }}) / 2
        when {{ column1 }} is not null then {{ column1 }}
        when {{ column2 }} is not null then {{ column2 }}
        else null
    end
{% endmacro %}