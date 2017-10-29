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

begin transaction;

insert into archive.mastodons
  (id, status_id, tweet_id,
    created_at, updated_at)
  (select
    nextval('statuses_id_seq'), nextval('statuses_id_seq'), id,
    now(), now()
    from archive.tweets where user_screen_name = 'BonzoESC'
    order by created_at asc);

insert into statuses
       (id, account_id, text, created_at, updated_at, visibility,
        spoiler_text, favourites_count, reblogs_count, "language")
(select
        m.id, 2, t.text, t.created_at, t.created_at, 0,
        '', 0, 0, 'en'
        from archive.mastodons as m
        join archive.tweets as t on t.id = m.tweet_id
        where t.user_screen_name = 'BonzoESC');

insert into stream_entries
       (activity_id, activity_type, created_at, updated_at, account_id)
       (select
         id, 'Status', created_at, updated_at, account_id
         from statuses);

update accounts
       set statuses_count = (select count(*) from statuses where account_id = 2)
       where id = 2;

commit;
