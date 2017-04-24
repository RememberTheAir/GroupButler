--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: array_distinct(anyarray); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION array_distinct(anyarray) RETURNS anyarray
    LANGUAGE sql IMMUTABLE
    AS $_$
  SELECT array_agg(DISTINCT x) FROM unnest($1) t(x);
$_$;


ALTER FUNCTION public.array_distinct(anyarray) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: chat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat (
    chatid bigint NOT NULL,
    lang text DEFAULT 'en'::text NOT NULL,
    owner integer,
    admins integer[],
    mods integer[],
    lastmsg timestamp with time zone DEFAULT now() NOT NULL,
    timezone text DEFAULT 'UTC'::text NOT NULL,
    members integer[],
    floodexceptions text[],
    rtl text,
    arab text,
    CONSTRAINT chat_lastmsg_ts_check CHECK ((date_part('timezone'::text, lastmsg) = '0'::double precision))
);


ALTER TABLE chat OWNER TO postgres;

--
-- Name: stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stats (
    chatid bigint NOT NULL,
    messages bigint DEFAULT 1 NOT NULL
);


ALTER TABLE stats OWNER TO postgres;

--
-- Name: tolog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tolog (
    chatid bigint NOT NULL,
    ban boolean DEFAULT false NOT NULL,
    kick boolean DEFAULT false NOT NULL,
    unban boolean DEFAULT false NOT NULL,
    tempban boolean DEFAULT false NOT NULL,
    report boolean DEFAULT false NOT NULL,
    warn boolean DEFAULT false NOT NULL,
    nowarn boolean DEFAULT false NOT NULL,
    mediawarn boolean DEFAULT false NOT NULL,
    spamwarn boolean DEFAULT false NOT NULL,
    flood boolean DEFAULT false NOT NULL,
    promote boolean DEFAULT false NOT NULL,
    demote boolean DEFAULT false NOT NULL,
    cleanmods boolean DEFAULT false NOT NULL,
    new_chat_member boolean DEFAULT false NOT NULL,
    new_chat_photo boolean DEFAULT false NOT NULL,
    delete_chat_photo boolean DEFAULT false NOT NULL,
    new_chat_title boolean DEFAULT false NOT NULL,
    pinned_message boolean DEFAULT false NOT NULL,
    blockban boolean DEFAULT false NOT NULL,
    block boolean DEFAULT false NOT NULL,
    unblock boolean DEFAULT false NOT NULL
);


ALTER TABLE tolog OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    userid integer NOT NULL,
    username text NOT NULL,
    blocked boolean DEFAULT false NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: chat chat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat
    ADD CONSTRAINT chat_pkey PRIMARY KEY (chatid);


--
-- Name: stats stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (chatid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- PostgreSQL database dump complete
--

