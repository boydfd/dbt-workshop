{{ config(materialized='incremental') }}


with
origin_fact as (select
    *
from {{ source('dbt_ods', 'pipeline_build') }}

    {% if is_incremental() %}

  -- this filter will only be applied on an incremental run

where date > (select max(date) from {{ this }})

    {% endif %}
),
dim as (
    select
    id,
    dbt_scd_id,
    dbt_valid_from,
    case when dbt_valid_to is null then
    to_timestamp('2038-01-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.US')
    else dbt_valid_to end as dbt_valid_to
    from {{ref('user_dim')}}
    ),
step1 as (
    select origin_fact.*,
    dim.dbt_scd_id as user_scd_id
    from origin_fact
    join  dim
    on origin_fact.user_id = dim.id and origin_fact.updated_at >= dim.dbt_valid_from and origin_fact.updated_at < dim.dbt_valid_to
    union all
    select origin_fact.*,
    cast ( -1 as char(32)) as user_scd_id
    from origin_fact
    where origin_fact.user_id is null
)

select * from step1
