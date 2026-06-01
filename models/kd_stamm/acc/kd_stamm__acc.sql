select
    {{ dbt_utils.star(from=ref('kd_stamm__cor')) }}
from {{ ref('kd_stamm__cor') }}
