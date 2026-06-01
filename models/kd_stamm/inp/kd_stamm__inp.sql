select
    {{ dbt_utils.star(from=source('fva', 'kd_stamm')) }}
from {{ source('fva', 'kd_stamm') }}
