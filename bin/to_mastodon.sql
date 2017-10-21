-- one-time-only configuration

CREATE EXTENSION postgres_fdw;
CREATE EXTENSION postgis;
CREATE SERVER archive
       FOREIGN DATA WRAPPER postgres_fdw
       OPTIONS (dbname 'bonzoesc_tweets');
-- CREATE SERVER mastodon
--        FOREIGN DATA WRAPPER postgres_fdw
--        OPTIONS (dbname 'mastodon_development');
CREATE SCHEMA archive;
-- CREATE SCHEMA mastodon;
CREATE USER MAPPING FOR CURRENT_USER SERVER archive;
-- CREATE USER MAPPING FOR CURRENT_USER SERVER mastodon;
IMPORT FOREIGN SCHEMA public FROM SERVER archive INTO archive;
-- IMPORT FOREIGN SCHEMA public FROM SERVER mastodon INTO mastodon;

insert into statuses
       (id, account_id, text, created_at, updated_at, visibility,
        spoiler_text, favourites_count, reblogs_count, "language")
(select
        nextval('statuses_id_seq'), 2, text, created_at, created_at, 0,
        '', 0, 0, 'en'
        from archive.tweets where user_screen_name = 'BonzoESC');

update accounts
       set statuses_count = (select count(*) from statuses where account_id = 2)
       where id = 2;
