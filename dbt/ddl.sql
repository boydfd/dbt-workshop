create database dbt_ods;
GRANT ALL ON dbt_ods.* TO 'dbt'@'%';

create database dbt_ods;
create database dbt_dim;
GRANT ALL ON dbt_dim.* TO 'dbt'@'%';

create database dbt_ods;
create database dbt_dim;
create database dbt_dwd;
GRANT ALL ON dbt_dwd.* TO 'dbt'@'%';

create database dbt;
create database dbt_ods;
create database dbt_dim;
create database dbt_dwd;
create database dbt_ads;
GRANT ALL ON dbt_ads.* TO 'dbt'@'%';

FLUSH PRIVILEGES;

use dbt_ods;
drop table if exists dbt_ods.user;
CREATE TABLE dbt_ods.user
(
    `id`         BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `ip`         VARCHAR(32)         NOT NULL,
    `age`        INT,
    `platform`   ENUM ('w','l','m')  NOT NULL,
    `date`       TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = INNODB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;


insert into dbt_ods.user(ip, platform, age)
values ('192.168.0.1', 'w', 1)
     , ('192.168.0.2', 'm', null)
;

select *
from dbt_dim.user_dim;

update user
set ip = '10.0.0.1'
where id = 1;

select *
from dbt_dim.user_dim;

update user
set age = 2
where id = 2;

select *
from dbt_dim.user_dim;

delete
from user
where id = 1;



drop table if exists dbt_ods.pipeline_build;
CREATE TABLE dbt_ods.pipeline_build
(
    `id`           BIGINT(20) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `pipeline_id`  INT                    NOT NULL,
    `user_id`      INT,
    `trigger_type` ENUM ('manual','auto') NOT NULL,
    `version`      INT,
    `project_id`   INT                    NOT NULL,
    `date`         TIMESTAMP              NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`   TIMESTAMP              NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = INNODB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

insert into pipeline_build(pipeline_id, user_id, trigger_type, version, project_id)
values (1, 1, 'manual', 1, 1)
     , (1, null, 'auto', 2, 1)
;

select *
from pipeline_build;
