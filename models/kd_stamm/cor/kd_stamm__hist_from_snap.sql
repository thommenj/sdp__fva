{{ config(materialized='incremental', unique_key=['kd_stamm_bk','load_ts']) }}

with base as (
    select
        {{ generate_bk(['kd_lnr','userbk_nr']) }} as kd_stamm_bk,
        dbt_valid_from as tec_gueltig_von,
        dbt_valid_to as tec_gueltig_bis,
        (dbt_valid_to = {{ var('high_date') }}) as ist_aktuell,
        dbt_is_deleted as ist_geloescht,
        dbt_updated_at as tec_geladen_am,
        {{ dbt_utils.star(from=ref('kd_stamm__snapshot'), except=['dbt_scd_id','dbt_valid_from','dbt_valid_to','dbt_is_deleted','dbt_updated_at']) }}
    from {{ ref('kd_stamm__snapshot') }}

    {% if is_incremental() %}
        where load_ts > (select coalesce(max(target.tec_gueltig_von), '1900-01-01') from {{ this }} as target)
    {% endif %}
)

select *
from base
