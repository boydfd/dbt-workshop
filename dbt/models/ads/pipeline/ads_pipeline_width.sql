select fact.*, dim.age, dim.ip, dim.platform from {{ ref('pipeline_build_fact') }} fact
join {{ ref('user_dim') }} dim
on fact.user_scd_id = dim.dbt_scd_id

