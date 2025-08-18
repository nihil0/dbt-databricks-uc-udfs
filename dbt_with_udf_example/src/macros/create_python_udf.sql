{% macro create_python_udf(name) %}
    {% set f = var("pyudfs")[name] %}
    {% set stmt %}
    CREATE OR REPLACE FUNCTION {{target.catalog}}.{{target.schema}}.{{name}}(
       {%- set arg_pairs = [] %}
        {%- for a in f['args'] -%}
            {% do arg_pairs.append(a['name'] ~ ' ' ~ a['type']) %}
        {%- endfor -%}
        {{ arg_pairs | join(', ') -}}
    )
    RETURNS {{ f["returns"] }}
    LANGUAGE PYTHON
    ENVIRONMENT(
        dependencies = '["/Volumes/{{target.catalog}}/{{target.schema}}/{{f["whl_path"]}}"]',
        environment_version = 'None'
    )
    AS $$
    from {{ f["package_name"] }} import {{ f["module_name"] }}
    return {{ f["module_name"] }}.{{ name }}(
        {%- set arg_pairs = [] %}
        {%- for a in f['args'] -%}
            {% do arg_pairs.append(a['name']) %}
        {%- endfor -%}
        {{ arg_pairs | join(', ') -}}
    )
    $$
    {% endset %}
    {% do run_query(stmt) %}
{% endmacro %}
