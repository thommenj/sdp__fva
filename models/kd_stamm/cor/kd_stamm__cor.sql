select
    {{ dbt_utils.star(from=ref('kd_stamm__inp')) }}
from {{ ref('kd_stamm__inp') }}
