-- macros/generate_bk.sql
--
-- Erzeugt den konsolidierten Business Key einer Entität als Pipe-konkatenierten
-- String aller fachlichen Schlüsselattribute.
--
-- Normalisierungsregeln (verbindlich für Reproduzierbarkeit):
--   - String-Cast aller Inputs auf VARCHAR
--   - TRIM führender und abschließender Leerzeichen
--   - NULL und Leerstrings werden durch das Sentinel '__NULL__' ersetzt
--   - Trenner zwischen Komponenten: '|' (einfache Pipe)
--
-- Verwendung:
--   {{ generate_bk(['USERBK_NR', 'KD_LNR']) }} as kd_stamm_bk
--
{% macro generate_bk(columns) %}

    {#- Einzelne Spalte als String erlaubt. Zu Liste konvertieren -#}
    {%- if columns is string -%}
        {%- set columns = [columns] -%}
    {%- endif -%}

    {%- if columns | length == 0 -%}
        {{ exceptions.raise_compiler_error(
            "generate_bk: mindestens eine Spalte erforderlich."
        ) }}
    {%- endif -%}

    concat_ws(
        '|',
        {%- for column in columns %}
        coalesce(nullif(trim(cast({{ column }} as varchar)), ''), '__NULL__')
        {%- if not loop.last -%},{%- endif %}
        {%- endfor %}
    )

{% endmacro %}