{% macro get_citibike_dataset() %}
    {% if target.name == 'dev' %}
        {{ return(var('dev_Citibike2526')) }}
    {% else %}
        {{ return(var('Citibike2526')) }}
    {% endif %}
{% endmacro %}
