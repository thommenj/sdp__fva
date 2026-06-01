{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- if custom_schema_name is none -%}
        {# Wenn kein custom schema definiert ist, nutze den Standard aus profiles.yml #}
        {{ target.schema }}
    {%- else -%}
        {# Wenn ein custom schema definiert ist, nutze NUR dieses ohne Präfix #}
        {{ custom_schema_name | trim }}
    {%- endif -%}

{%- endmacro %}


-- If prefix should only be left out in PROD
-- {% macro generate_schema_name1(custom_schema_name, node) -%}
--     {# In Produktion wird das nackte Custom Schema genutzt #}
--     {%- if target.name == 'prod' and custom_schema_name is not none -%}
--         {{ custom_schema_name | trim }}
--     {# In Dev/Lokal wird zur Sicherheit weiterhin das Präfix genutzt #}
--     {%- elif custom_schema_name is not none -%}
--         {{ target.schema }}_{{ custom_schema_name | trim }}
--     {%- else -%}
--         {{ target.schema }}
--     {%- endif -%}
-- {%- endmacro %}

