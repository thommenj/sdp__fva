{{ config(materialized='incremental', unique_key=['kd_stamm_bk','load_ts']) }}

with raw as (
    select
        {{ generate_bk(['kd_lnr','userbk_nr']) }} as kd_stamm_bk,
        load_ts as tec_gueltig_von,
        {{ dbt_utils.star(from=ref('kd_stamm__inp')) }}
    from {{ ref('kd_stamm__inp') }}

    {% if is_incremental() %}
        where load_ts > (select coalesce(max(target.tec_gueltig_von), '1900-01-01') from {{ this }} as target)
    {% endif %}
),

versionen as (
    select
        kd_stamm_bk,
        tec_gueltig_von,
        coalesce(
            lead(tec_gueltig_von) over (partition by kd_stamm_bk order by tec_gueltig_von),
            {{ var('high_date') }}
        ) as tec_gueltig_bis,
        {{ dbt_utils.star(from=ref('kd_stamm__inp')) }}
    from raw
)

select
    kd_stamm_bk,
    tec_gueltig_von,
    tec_gueltig_bis,
    (tec_gueltig_bis = {{ var('high_date') }}) as ist_aktuell,
    false as ist_geloescht,
    current_timestamp as tec_geladen_am,
    {{ dbt_utils.star(from=ref('kd_stamm__inp')) }}
from versionen
