--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attachments (
    id integer NOT NULL,
    tweet_id uuid,
    media_attachment_id integer,
    index integer,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachments.id;


--
-- Name: mastodons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mastodons (
    id integer NOT NULL,
    tweet_id uuid,
    status_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mastodons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mastodons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mastodons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mastodons_id_seq OWNED BY mastodons.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: tweets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tweets (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    id_str character varying(255),
    text character varying(255),
    body json,
    id_number numeric,
    created_at timestamp without time zone,
    geo_point geography(Point,4326),
    default_image_file_name character varying(255),
    default_image_content_type character varying(255),
    default_image_file_size integer,
    default_image_updated_at timestamp without time zone,
    retweeted_status_id character varying(255),
    in_reply_to_status_id character varying(255),
    user_id numeric,
    user_display_name character varying(255),
    user_screen_name character varying(255)
);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- Name: mastodons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mastodons ALTER COLUMN id SET DEFAULT nextval('mastodons_id_seq'::regclass);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: mastodons mastodons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mastodons
    ADD CONSTRAINT mastodons_pkey PRIMARY KEY (id);


--
-- Name: tweets tweets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tweets
    ADD CONSTRAINT tweets_pkey PRIMARY KEY (id);


--
-- Name: index_attachments_on_tweet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_tweet_id ON attachments USING btree (tweet_id);


--
-- Name: index_mastodons_on_tweet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mastodons_on_tweet_id ON mastodons USING btree (tweet_id);


--
-- Name: index_tweets_on_geo_point; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_geo_point ON tweets USING gist (geo_point);


--
-- Name: index_tweets_on_id_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tweets_on_id_number ON tweets USING btree (id_number);


--
-- Name: index_tweets_on_in_reply_to_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_in_reply_to_status_id ON tweets USING btree (in_reply_to_status_id);


--
-- Name: index_tweets_on_retweeted_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_retweeted_status_id ON tweets USING btree (retweeted_status_id);


--
-- Name: index_tweets_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_user_id ON tweets USING btree (user_id);


--
-- Name: index_tweets_on_user_screen_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_user_screen_name ON tweets USING btree (user_screen_name);


--
-- Name: tweets_geometry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tweets_geometry ON tweets USING gist (((geo_point)::geometry));


--
-- Name: tweets_text_fulltext; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tweets_text_fulltext ON tweets USING gin (to_tsvector('english'::regconfig, (text)::text));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: mastodons fk_rails_8df3c5d046; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mastodons
    ADD CONSTRAINT fk_rails_8df3c5d046 FOREIGN KEY (tweet_id) REFERENCES tweets(id);


--
-- Name: attachments fk_rails_a158c64989; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT fk_rails_a158c64989 FOREIGN KEY (tweet_id) REFERENCES tweets(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('0');

INSERT INTO schema_migrations (version) VALUES ('20140606024739');

INSERT INTO schema_migrations (version) VALUES ('20140606031540');

INSERT INTO schema_migrations (version) VALUES ('20140606040937');

INSERT INTO schema_migrations (version) VALUES ('20140606050424');

INSERT INTO schema_migrations (version) VALUES ('20140610000130');

INSERT INTO schema_migrations (version) VALUES ('20140814031644');

INSERT INTO schema_migrations (version) VALUES ('20140814151955');

INSERT INTO schema_migrations (version) VALUES ('20140820225444');

INSERT INTO schema_migrations (version) VALUES ('20141011133910');

INSERT INTO schema_migrations (version) VALUES ('20160110152949');

INSERT INTO schema_migrations (version) VALUES ('20160110153000');

INSERT INTO schema_migrations (version) VALUES ('20171029180302');

INSERT INTO schema_migrations (version) VALUES ('20171105184112');

