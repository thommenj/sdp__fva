-- macros/high_date_value.sql
--
-- Liefert den plattformweit verbindlichen High-Date-Sentinel-Wert.
--
-- Der Wert ist hardcoded und gilt plattformweit für alle Datenprodukte.
-- Eine Anpassung gilt als Breaking Change, erfordert einen neuen Release des
-- zentralen Packages und einen Re-Build aller SCD2-historisierten Datenprodukte.
--
-- Alternativ kann mit einer Variable gearbeitet werden, die in der dbt_project.yml definiert ist. Das hat den Vorteil, dass der Wert ohne Code-Änderung angepasst werden kann.
-- Dadurch könnten andere Datenprodukte einen anderen High-Date-Wert nutzen, was aber zu Inkonsistenzen führen könnte. Daher ist die Nutzung einer Variable aktuell nicht vorgesehen.
--
{% macro high_date_value() -%}
    cast('2299-12-31 23:59:59.999' as timestamp(3))
{%- endmacro %}