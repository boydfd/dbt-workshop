{% snapshot user_dim %}

{{
    config(
      target_database='dbt',
      target_schema='dbt_dim',
      unique_key='id',
      strategy='timestamp',
      updated_at='updated_at',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ source('dbt_ods', 'user') }}

{% endsnapshot %}