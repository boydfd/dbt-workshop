create user dbt with encrypted password 'dbt-password';
create user superset with encrypted password 'superset-password';
create database superset;
grant all privileges on database superset to superset;

create database dbt;
CREATE SCHEMA dbt.dbt_ods;
CREATE SCHEMA dbt.dbt_dim;
CREATE SCHEMA dbt.dbt_dwd;
CREATE SCHEMA dbt.dbt_ads;
CREATE SCHEMA dbt.dbt;

grant all privileges on database dbt to dbt;

GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt TO dbt;
GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt_ods TO dbt;
GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt_dim TO dbt;
GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt_dwd TO dbt;
GRANT all privileges ON ALL TABLES IN SCHEMA dbt.dbt_ads TO dbt;

GRANT all privileges ON  SCHEMA dbt.dbt TO dbt;
GRANT all privileges ON  SCHEMA dbt.dbt_ods TO dbt;
GRANT all privileges ON  SCHEMA dbt.dbt_dim TO dbt;
GRANT all privileges ON  SCHEMA dbt.dbt_dwd TO dbt;
GRANT all privileges ON  SCHEMA dbt.dbt_ads TO dbt;

create database dbt_ods;
grant all privileges on database dbt_ods to dbt;
create database dbt_dim;
grant all privileges on database dbt_dim to dbt;
create database dbt_dwd;
grant all privileges on database dbt_dwd to dbt;
create database dbt_ads;
grant all privileges on database dbt_ads to dbt;





drop table if exists dbt_ods.user;
drop table if exists dbt_dim.user_dim;

CREATE OR REPLACE FUNCTION update_modified_column()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE dbt_ods.user
(
    id         BIGINT          NOT NULL GENERATED ALWAYS AS IDENTITY,
    ip         VARCHAR(32)     NOT NULL,
    age        INT,
    platform   VARCHAR(1)      NOT NULL CHECK (platform IN ('w','l','m')),
    date       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);
CREATE TRIGGER update_customer_modtime BEFORE UPDATE ON dbt_ods.user FOR EACH ROW EXECUTE PROCEDURE  update_modified_column();



insert into dbt_ods.user(ip, platform, age, date, updated_at)
values ('192.168.0.1', 'w', 1, '2022-12-01'::timestamp, '2022-12-01'::timestamp)
     , ('192.168.0.2', 'm', null, '2022-12-01'::timestamp, '2022-12-01'::timestamp);

select * from dbt.dbt_ods.user;

select *
from dbt_dim.user_dim;

update dbt.dbt_ods.user
set ip = '10.0.0.1'
where id = 1;

select *
from dbt_dim.user_dim;

update dbt.dbt_ods.user
set age = 2
where id = 2;

select *
from dbt_dim.user_dim;

delete
from dbt.dbt_ods.user
where id = 1;

select *
from dbt_dim.user_dim;

insert into dbt_dim.user_dim(id, ip, age, platform, date, updated_at, dbt_scd_id, dbt_updated_at, dbt_valid_from, dbt_valid_to)
values (-1, 'UNKNWON', NULL, 'U', '1970-01-01'::timestamp, '1970-01-01'::timestamp, -1, '1970-01-01'::timestamp, '1970-01-01'::timestamp, null);

drop table if exists dbt.dbt_ods.pipeline_build;
drop table if exists dbt.dbt_dwd.pipeline_build_fact;
CREATE TABLE dbt_ods.pipeline_build
(
    id           BIGINT               PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    pipeline_id  INTEGER              NOT NULL,
    user_id      INTEGER,
    trigger_type VARCHAR(6)           NOT NULL,
    version      INTEGER,
    project_id   INTEGER              NOT NULL,
    date         TIMESTAMP            NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP            NOT NULL DEFAULT NOW()
) ;
CREATE TRIGGER update_customer_modtime BEFORE UPDATE ON dbt_ods.pipeline_build FOR EACH ROW EXECUTE PROCEDURE  update_modified_column();

INSERT INTO dbt_ods.pipeline_build(pipeline_id, user_id, trigger_type, version, project_id, date, updated_at)
VALUES (1, 1, 'manual', 1, 1, '2023-01-01'::timestamp, '2023-01-01'::timestamp)
     , (1, null, 'auto', 2, 1, '2023-01-01'::timestamp, '2023-01-01'::timestamp)
;
INSERT INTO dbt_ods.pipeline_build(pipeline_id, user_id, trigger_type, version, project_id, updated_at, date)
VALUES
    (1, 1, 'manual', 1, 1, '2023-02-01'::timestamp,'2023-02-01'::timestamp),
    (1, null, 'auto', 2, 1, '2023-02-01'::timestamp,'2023-02-01'::timestamp),
    (1, 1, 'test1', 3, 1, '2023-02-02'::timestamp,'2023-02-02'::timestamp),
    (1, null, 'test2', 4, 1, '2023-02-02'::timestamp,'2023-02-02'::timestamp),
    (1, 1, 'manual', 5, 1, '2023-02-03'::timestamp,'2023-02-03'::timestamp),
    (1, null, 'auto', 6, 1, '2023-02-03'::timestamp,'2023-02-03'::timestamp),
    (1, 1, 'test1', 7, 1, '2023-02-04'::timestamp,'2023-02-04'::timestamp),
    (1, null, 'test2', 8, 1, '2023-02-04'::timestamp,'2023-02-04'::timestamp),
    (1, 1, 'manual', 9, 1, '2023-02-05'::timestamp,'2023-02-05'::timestamp),
    (1, null, 'auto', 10, 1, '2023-02-05'::timestamp,'2023-02-05'::timestamp),
    (1, 1, 'test1', 11, 1, '2023-02-06'::timestamp,'2023-02-06'::timestamp),
    (1, null, 'test2', 12, 1, '2023-02-06'::timestamp,'2023-02-06'::timestamp),
    (1, 1, 'manual', 13, 1, '2023-02-07'::timestamp,'2023-02-07'::timestamp),
    (1, null, 'auto', 14, 1, '2023-02-07'::timestamp,'2023-02-07'::timestamp),
    (1, 1, 'test1', 15, 1, '2023-02-08'::timestamp,'2023-02-08'::timestamp),
    (1, null, 'test2', 16, 1, '2023-02-08'::timestamp,'2023-02-08'::timestamp),
    (1, 1, 'manual', 17, 1, '2023-02-09'::timestamp,'2023-02-09'::timestamp),
    (1, null, 'auto', 18, 1, '2023-02-09'::timestamp,'2023-02-09'::timestamp),
    (1, 1, 'test1', 19, 1, '2023-02-10'::timestamp,'2023-02-10'::timestamp),
    (1, null, 'test2', 20, 1, '2023-02-10'::timestamp,'2023-02-10'::timestamp),
    (1, 1, 'manual', 21, 1, '2023-02-11'::timestamp,'2023-02-11'::timestamp),
    (1, null, 'auto', 22, 1, '2023-02-11'::timestamp,'2023-02-11'::timestamp),
    (1, 1, 'test1', 23, 1, '2023-02-12'::timestamp,'2023-02-12'::timestamp),
    (1, null, 'test2', 24, 1, '2023-02-12'::timestamp,'2023-02-12'::timestamp),
    (1, 1, 'manual', 25, 1, '2023-02-13'::timestamp,'2023-02-13'::timestamp),
    (1, null, 'auto', 26, 1, '2023-02-13'::timestamp,'2023-02-13'::timestamp),
    (1, 1, 'test1', 27, 1, '2023-02-14'::timestamp,'2023-02-14'::timestamp),
    (1, null, 'test2', 28, 1, '2023-02-14'::timestamp,'2023-02-14'::timestamp),
    (1, 1, 'manual', 29, 1, '2023-02-15'::timestamp,'2023-02-15'::timestamp),
    (1, null, 'auto', 30, 1, '2023-02-15'::timestamp,'2023-02-15'::timestamp),
    (1, 1, 'test1', 31, 1, '2023-02-16'::timestamp,'2023-02-16'::timestamp),
    (1, null, 'test2', 32, 1, '2023-02-16'::timestamp,'2023-02-16'::timestamp),
    (1, 1, 'manual', 33, 1, '2023-02-17'::timestamp,'2023-02-17'::timestamp),
    (1, null, 'auto', 34, 1, '2023-02-17'::timestamp,'2023-02-17'::timestamp),
    (1, 1, 'test1', 35, 1, '2023-02-18'::timestamp,'2023-02-18'::timestamp),
    (1, null, 'test2', 36, 1, '2023-02-18'::timestamp,'2023-02-18'::timestamp),
    (1, 1, 'manual', 37, 1, '2023-02-19'::timestamp,'2023-02-19'::timestamp),
    (1, null, 'auto', 38, 1, '2023-02-19'::timestamp,'2023-02-19'::timestamp),
    (1, 1, 'test1', 39, 1, '2023-02-20'::timestamp,'2023-02-20'::timestamp),
    (1, null, 'test2', 40, 1, '2023-02-20'::timestamp,'2023-02-20'::timestamp),
    (1, 1, 'manual', 41, 1, '2023-02-21'::timestamp,'2023-02-21'::timestamp),
    (1, null, 'auto', 42, 1, '2023-02-21'::timestamp,'2023-02-21'::timestamp),
    (1, 1, 'test1', 43, 1, '2023-02-22'::timestamp,'2023-02-22'::timestamp),
    (1, null, 'test2', 44, 1, '2023-02-22'::timestamp,'2023-02-22'::timestamp),
    (1, 1, 'manual', 45, 1, '2023-02-23'::timestamp,'2023-02-23'::timestamp),
    (1, null, 'auto', 46, 1, '2023-02-23'::timestamp,'2023-02-23'::timestamp),
    (1, 1, 'test1', 47, 1, '2023-02-24'::timestamp,'2023-02-24'::timestamp),
    (1, null, 'test2', 48, 1, '2023-02-24'::timestamp,'2023-02-24'::timestamp),
    (1, 1, 'manual', 49, 1, '2023-02-25'::timestamp,'2023-02-25'::timestamp),
    (1, null, 'auto', 50, 1, '2023-02-25'::timestamp,'2023-02-25'::timestamp),
    (1, 1, 'test1', 51, 1, '2023-02-26'::timestamp,'2023-02-26'::timestamp),
    (1, null, 'test2', 52, 1, '2023-02-26'::timestamp,'2023-02-26'::timestamp),
    (1, 1, 'manual', 53, 1, '2023-02-27'::timestamp,'2023-02-27'::timestamp),
    (1, null, 'auto', 54, 1, '2023-02-27'::timestamp,'2023-02-27'::timestamp),
    (1, 1, 'test1', 55, 1, '2023-02-28'::timestamp,'2023-02-28'::timestamp),
    (1, null, 'test2', 56, 1, '2023-02-28'::timestamp,'2023-02-28'::timestamp),
    (1, 1, 'manual', 57, 1, '2023-03-01'::timestamp,'2023-03-01'::timestamp),
    (1, null, 'auto', 58, 1, '2023-03-01'::timestamp,'2023-03-01'::timestamp),
    (1, 1, 'test1', 59, 1, '2023-03-02'::timestamp,'2023-03-02'::timestamp),
    (1, null, 'test2', 60, 1, '2023-03-02'::timestamp,'2023-03-02'::timestamp),
    (1, 1, 'manual', 61, 1, '2023-03-03'::timestamp,'2023-03-03'::timestamp),
    (1, null, 'auto', 62, 1, '2023-03-03'::timestamp,'2023-03-03'::timestamp),
    (1, 1, 'test1', 63, 1, '2023-03-04'::timestamp,'2023-03-04'::timestamp),
    (1, null, 'test2', 64, 1, '2023-03-04'::timestamp,'2023-03-04'::timestamp),
    (1, 1, 'manual', 65, 1, '2023-03-05'::timestamp,'2023-03-05'::timestamp),
    (1, null, 'auto', 66, 1, '2023-03-05'::timestamp,'2023-03-05'::timestamp),
    (1, 1, 'test1', 67, 1, '2023-03-06'::timestamp,'2023-03-06'::timestamp),
    (1, null, 'test2', 68, 1, '2023-03-06'::timestamp,'2023-03-06'::timestamp),
    (1, 1, 'manual', 69, 1, '2023-03-01'::timestamp,'2023-03-01'::timestamp),
    (1, null, 'auto', 70, 1, '2023-03-01'::timestamp,'2023-03-01'::timestamp),
    (1, 1, 'test1', 71, 1, '2023-03-02'::timestamp,'2023-03-02'::timestamp),
    (1, null, 'test2', 72, 1, '2023-03-02'::timestamp,'2023-03-02'::timestamp),
    (1, 1, 'manual', 73, 1, '2023-03-03'::timestamp,'2023-03-03'::timestamp),
    (1, null, 'auto', 74, 1, '2023-03-03'::timestamp,'2023-03-03'::timestamp),
    (1, 1, 'test1', 75, 1, '2023-03-04'::timestamp,'2023-03-04'::timestamp),
    (1, null, 'test2', 76, 1, '2023-03-04'::timestamp,'2023-03-04'::timestamp),
    (1, 1, 'manual', 77, 1, '2023-03-05'::timestamp,'2023-03-05'::timestamp),
    (1, null, 'auto', 78, 1, '2023-03-05'::timestamp,'2023-03-05'::timestamp),
    (1, 1, 'test1', 79, 1, '2023-03-06'::timestamp,'2023-03-06'::timestamp),
    (1, null, 'test2', 80, 1, '2023-03-06'::timestamp,'2023-03-06'::timestamp),
    (1, 1, 'manual', 81, 1, '2023-03-01'::timestamp,'2023-03-01'::timestamp),
    (1, null, 'auto', 82, 1, '2023-03-01'::timestamp,'2023-03-01'::timestamp),
    (1, 1, 'test1', 83, 1, '2023-03-02'::timestamp,'2023-03-02'::timestamp),
    (1, null, 'test2', 84, 1, '2023-03-02'::timestamp,'2023-03-02'::timestamp),
    (1, 1, 'manual', 85, 1, '2023-03-03'::timestamp,'2023-03-03'::timestamp),
    (1, null, 'auto', 86, 1, '2023-03-03'::timestamp,'2023-03-03'::timestamp),
    (1, 1, 'test1', 87, 1, '2023-03-04'::timestamp,'2023-03-04'::timestamp),
    (1, null, 'test2', 88, 1, '2023-03-04'::timestamp,'2023-03-04'::timestamp),
    (1, 1, 'manual', 89, 1, '2023-03-05'::timestamp,'2023-03-05'::timestamp),
    (1, null, 'auto', 90, 1, '2023-03-05'::timestamp,'2023-03-05'::timestamp),
    (1, 1, 'test1', 91, 1, '2023-03-06'::timestamp,'2023-03-06'::timestamp),
    (1, null, 'test2', 92, 1, '2023-03-06'::timestamp,'2023-03-06'::timestamp),
    (1, 1, 'manual', 93, 1, '2023-03-01'::timestamp,'2023-03-01'::timestamp),
    (1, null, 'auto', 94, 1, '2023-03-01'::timestamp,'2023-03-01'::timestamp),
    (1, 1, 'test1', 95, 1, '2023-03-02'::timestamp,'2023-03-02'::timestamp),
    (1, null, 'test2', 96, 1, '2023-03-02'::timestamp,'2023-03-02'::timestamp),
    (1, 1, 'manual', 97, 1, '2023-03-03'::timestamp,'2023-03-03'::timestamp),
    (1, null, 'auto', 98, 1, '2023-03-03'::timestamp,'2023-03-03'::timestamp),
    (1, 1, 'test1', 99, 1, '2023-03-04'::timestamp,'2023-03-04'::timestamp),
    (1, null, 'test2', 100, 1, '2023-03-04'::timestamp,'2023-03-04'::timestamp);

INSERT INTO dbt_ods.pipeline_build(pipeline_id, user_id, trigger_type, version, project_id, date, updated_at)
VALUES (1, 2, 'auto', 2, 1, '2023-04-01'::timestamp, '2023-04-01'::timestamp)
;

select *
from dbt_ods.pipeline_build;

select *
from dbt_dwd.pipeline_build_fact;



select * from dbt_ads.ads_pipeline_metric;
select * from dbt_ads.ads_pipeline_width;