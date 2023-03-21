set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

  -- create user superset with encrypted password 'superset-password';
  -- create database superset;
  -- grant all privileges on database superset to superset;

	create user airflow with encrypted password 'airflow-password';
  create database airflow;
  grant all privileges on database airflow to airflow;

	create user dbt with encrypted password 'dbt-password';
  create database dbt;
  grant all privileges on database dbt to dbt;

	\c airflow
	CREATE SCHEMA IF NOT EXISTS airflow AUTHORIZATION airflow;
  GRANT all privileges ON SCHEMA public TO airflow;

  \c dbt
	CREATE SCHEMA IF NOT EXISTS dbt_ods AUTHORIZATION dbt;
	CREATE SCHEMA IF NOT EXISTS dbt_dim AUTHORIZATION dbt;
	CREATE SCHEMA IF NOT EXISTS dbt_dwd AUTHORIZATION dbt;
	CREATE SCHEMA IF NOT EXISTS dbt_ads AUTHORIZATION dbt;
	CREATE SCHEMA IF NOT EXISTS dbt AUTHORIZATION dbt;
  GRANT all privileges ON SCHEMA public TO dbt;


  -- CREATE SCHEMA dbt.dbt_ods;
  -- CREATE SCHEMA dbt.dbt_dim;
  -- CREATE SCHEMA dbt.dbt_dwd;
  -- CREATE SCHEMA dbt.dbt_ads;
  -- CREATE SCHEMA dbt.dbt;


  -- GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt TO dbt;
  -- GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt_ods TO dbt;
  -- GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt_dim TO dbt;
  -- GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt_dwd TO dbt;
  -- GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt_ads TO dbt;

  -- GRANT all privileges ON  SCHEMA dbt.dbt_ods TO dbt;
  -- GRANT all privileges ON  SCHEMA dbt.dbt_dim TO dbt;
  -- GRANT all privileges ON  SCHEMA dbt.dbt_dwd TO dbt;
  -- GRANT all privileges ON  SCHEMA dbt.dbt_ads TO dbt;

	SET datestyle = "ISO, DMY";
EOSQL