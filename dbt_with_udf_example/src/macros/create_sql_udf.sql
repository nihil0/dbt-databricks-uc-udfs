{% macro create_sql_udf(name) %}
    {% set f = var("sqludfs")[name] %}
    {% set stmt %}
    CREATE OR REPLACE FUNCTION {{target.catalog}}.{{target.schema}}.{{name}}(
       {%- set arg_pairs = [] %}
        {%- for a in f['args'] -%}
            {% do arg_pairs.append(a['name'] ~ ' ' ~ a['type']) %}
        {%- endfor -%}
        {{ arg_pairs | join(', ') -}}
    )
    RETURNS {{ f["returns"] }}
    LANGUAGE SQL
    AS $$
        {{ f["sql_stmt"] | replace("$CATALOG", target.catalog) | replace("$SCHEMA", target.schema) | trim }}
    $$
    {%- endset -%}
    {{ print(stmt) }}
    {# {% do run_query(stmt) %} #}
{% endmacro %}
