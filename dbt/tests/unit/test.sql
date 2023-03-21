{{
    config(
        tags=['unit-test', 'no-db-dependency']
    )
}}


{% call dbt_unit_testing.test('demo', 'should return 100') %}


  {% call dbt_unit_testing.expect() %}
select 100 as a
    {% endcall %}
{% endcall %}

{#
UNION ALL


{% call dbt_unit_testing.test('user_dim', 'should run snapshot') %}


{% call dbt_unit_testing.mock_source('dbt_ods', 'user', {"input_format": "csv"}) %}
user, a
1, 2
{% endcall %}

{% call dbt_unit_testing.expect() %}
select 100 as a, 2 as user , null as dbt_valid_to
{% endcall %}
{% endcall %}

#}