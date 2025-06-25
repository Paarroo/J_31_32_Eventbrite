--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Homebrew)
-- Dumped by pg_dump version 15.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: toto
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO toto;

--
-- Name: attendances; Type: TABLE; Schema: public; Owner: toto
--

CREATE TABLE public.attendances (
    id bigint NOT NULL,
    stripe_customer_id character varying,
    user_id bigint NOT NULL,
    event_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    stripe_checkout_session_id character varying,
    stripe_payment_intent_id character varying,
    payment_status character varying DEFAULT 'pending'::character varying,
    amount_paid integer,
    paid_at timestamp(6) without time zone
);


ALTER TABLE public.attendances OWNER TO toto;

--
-- Name: attendances_id_seq; Type: SEQUENCE; Schema: public; Owner: toto
--

CREATE SEQUENCE public.attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendances_id_seq OWNER TO toto;

--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: toto
--

ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: toto
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    title character varying,
    description text,
    start_date timestamp(6) without time zone,
    duration integer,
    price integer,
    location character varying,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.events OWNER TO toto;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: toto
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_id_seq OWNER TO toto;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: toto
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: toto
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    event_id bigint NOT NULL,
    attendance_id bigint,
    stripe_checkout_session_id character varying NOT NULL,
    stripe_payment_intent_id character varying,
    stripe_customer_id character varying,
    amount integer NOT NULL,
    currency character varying DEFAULT 'eur'::character varying,
    status character varying DEFAULT 'pending'::character varying,
    stripe_metadata text,
    paid_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.payments OWNER TO toto;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: toto
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO toto;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: toto
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: toto
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO toto;

--
-- Name: users; Type: TABLE; Schema: public; Owner: toto
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying,
    last_name character varying,
    description text,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone
);


ALTER TABLE public.users OWNER TO toto;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: toto
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO toto;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: toto
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: attendances id; Type: DEFAULT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: toto
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-06-17 12:36:45.790556	2025-06-17 12:36:45.790558
\.


--
-- Data for Name: attendances; Type: TABLE DATA; Schema: public; Owner: toto
--

COPY public.attendances (id, stripe_customer_id, user_id, event_id, created_at, updated_at, stripe_checkout_session_id, stripe_payment_intent_id, payment_status, amount_paid, paid_at) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: toto
--

COPY public.events (id, title, description, start_date, duration, price, location, user_id, created_at, updated_at) FROM stdin;
53	Événement 1	Description détaillée de l'événement 1. Ceci est un super événement qui va vous plaire énormément !	2025-07-16 20:00:00	60	70	Nice	30	2025-06-18 11:02:11.321473	2025-06-18 11:02:11.321473
54	Événement 2	Description détaillée de l'événement 2. Ceci est un super événement qui va vous plaire énormément !	2025-07-06 20:00:00	240	78	Toulouse	28	2025-06-18 11:02:11.326146	2025-06-18 11:02:11.326146
55	Événement 3	Description détaillée de l'événement 3. Ceci est un super événement qui va vous plaire énormément !	2025-07-11 12:00:00	120	45	Paris	28	2025-06-18 11:02:11.333408	2025-06-18 11:02:11.333408
56	Événement 4	Description détaillée de l'événement 4. Ceci est un super événement qui va vous plaire énormément !	2025-07-18 09:00:00	180	69	Nice	29	2025-06-18 11:02:11.335852	2025-06-18 11:02:11.335852
57	Événement 5	Description détaillée de l'événement 5. Ceci est un super événement qui va vous plaire énormément !	2025-07-09 20:00:00	60	11	Paris	31	2025-06-18 11:02:11.339096	2025-06-18 11:02:11.339096
58	Événement 6	Description détaillée de l'événement 6. Ceci est un super événement qui va vous plaire énormément !	2025-07-10 14:00:00	240	13	Nice	32	2025-06-18 11:02:11.341736	2025-06-18 11:02:11.341736
59	Événement 7	Description détaillée de l'événement 7. Ceci est un super événement qui va vous plaire énormément !	2025-06-29 15:00:00	180	97	Paris	30	2025-06-18 11:02:11.350869	2025-06-18 11:02:11.350869
60	Événement 8	Description détaillée de l'événement 8. Ceci est un super événement qui va vous plaire énormément !	2025-07-16 11:00:00	240	42	Lyon	28	2025-06-18 11:02:11.356005	2025-06-18 11:02:11.356005
61	Événement 9	Description détaillée de l'événement 9. Ceci est un super événement qui va vous plaire énormément !	2025-07-01 16:00:00	180	33	Toulouse	29	2025-06-18 11:02:11.360347	2025-06-18 11:02:11.360347
62	Événement 10	Description détaillée de l'événement 10. Ceci est un super événement qui va vous plaire énormément !	2025-07-18 19:00:00	180	60	Toulouse	30	2025-06-18 11:02:11.363255	2025-06-18 11:02:11.363255
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: toto
--

COPY public.payments (id, user_id, event_id, attendance_id, stripe_checkout_session_id, stripe_payment_intent_id, stripe_customer_id, amount, currency, status, stripe_metadata, paid_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: toto
--

COPY public.schema_migrations (version) FROM stdin;
20250617120218
20250617120528
20250617120721
20250617143358
20250620135456
20250620154023
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: toto
--

COPY public.users (id, first_name, last_name, description, email, encrypted_password, created_at, updated_at, reset_password_token, reset_password_sent_at, remember_created_at) FROM stdin;
28	Prénom1	Nom1	Description de l'utilisateur 1	user1@yopmail.com	$2a$12$l.D6j5pOU9A.PslfIMnMn.ip.A3UcLpUe1Q/GewaiejfpLi/0z9fa	2025-06-18 11:02:10.099055	2025-06-18 11:02:10.099055	\N	\N	\N
29	Prénom2	Nom2	Description de l'utilisateur 2	user2@yopmail.com	$2a$12$kY/xaHxvPWlPkg9UagYtC.eIs0fRzAwhskgEctpj3JWWygmjrhEsW	2025-06-18 11:02:10.495782	2025-06-18 11:02:10.495782	\N	\N	\N
30	Prénom3	Nom3	Description de l'utilisateur 3	user3@yopmail.com	$2a$12$qa9AEQCn8mY46j1peCcz3.VX.Od/xN7MWIOi0HO1n6m5bTcg/6fOe	2025-06-18 11:02:10.773109	2025-06-18 11:02:10.773109	\N	\N	\N
31	Prénom4	Nom4	Description de l'utilisateur 4	user4@yopmail.com	$2a$12$HNhz4oB5XpM9JT6f5If.teZBwudydxjL3ibxnlJBOhAm7TApBXoiu	2025-06-18 11:02:11.052897	2025-06-18 11:02:11.052897	\N	\N	\N
32	Prénom5	Nom5	Description de l'utilisateur 5	user5@yopmail.com	$2a$12$GibUvmbRM2b67V/GLwrRsON.HJjU.egKxqnmXCj3JvXv8/MXmRtlW	2025-06-18 11:02:11.313198	2025-06-18 11:02:11.313198	\N	\N	\N
33	toto	zec	dzedczecsdcsdc	czec@ghi.com	$2a$12$3XZzB.w02phEGpA4TRk3EehcuatSHTuaZKS7afffCdVZLmsVAvCu2	2025-06-18 11:05:32.957222	2025-06-18 11:05:32.957222	\N	\N	\N
39	paarroo	toto	osichscposqich^paoihjcôpihôih^poiuh	coucou@evenbrite	$2a$12$jmZtS8I6iv01T2DwrSGDQ.gYfWm4OXToAZhqOu3CFYO4zmjTq/5My	2025-06-19 22:39:14.076117	2025-06-19 22:39:14.076117	\N	\N	\N
40	cocoax	kzspmxcjhpilh	pihùopihùmopih	ljholh@mljm.fr	$2a$12$gQbkMTkpgnNhT1DW9qVmz.lYIL7yyvV4ZSAq1iURUaaOGEp1DIl0i	2025-06-19 22:50:45.02275	2025-06-19 22:50:45.02275	\N	\N	\N
\.


--
-- Name: attendances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: toto
--

SELECT pg_catalog.setval('public.attendances_id_seq', 6, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: toto
--

SELECT pg_catalog.setval('public.events_id_seq', 62, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: toto
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: toto
--

SELECT pg_catalog.setval('public.users_id_seq', 40, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_attendances_on_event_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_attendances_on_event_id ON public.attendances USING btree (event_id);


--
-- Name: index_attendances_on_payment_status; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_attendances_on_payment_status ON public.attendances USING btree (payment_status);


--
-- Name: index_attendances_on_stripe_checkout_session_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_attendances_on_stripe_checkout_session_id ON public.attendances USING btree (stripe_checkout_session_id);


--
-- Name: index_attendances_on_stripe_payment_intent_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_attendances_on_stripe_payment_intent_id ON public.attendances USING btree (stripe_payment_intent_id);


--
-- Name: index_attendances_on_user_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_attendances_on_user_id ON public.attendances USING btree (user_id);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_events_on_user_id ON public.events USING btree (user_id);


--
-- Name: index_payments_on_attendance_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_payments_on_attendance_id ON public.payments USING btree (attendance_id);


--
-- Name: index_payments_on_event_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_payments_on_event_id ON public.payments USING btree (event_id);


--
-- Name: index_payments_on_status; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_payments_on_status ON public.payments USING btree (status);


--
-- Name: index_payments_on_stripe_checkout_session_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE UNIQUE INDEX index_payments_on_stripe_checkout_session_id ON public.payments USING btree (stripe_checkout_session_id);


--
-- Name: index_payments_on_stripe_payment_intent_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_payments_on_stripe_payment_intent_id ON public.payments USING btree (stripe_payment_intent_id);


--
-- Name: index_payments_on_user_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_payments_on_user_id ON public.payments USING btree (user_id);


--
-- Name: index_payments_on_user_id_and_event_id; Type: INDEX; Schema: public; Owner: toto
--

CREATE INDEX index_payments_on_user_id_and_event_id ON public.payments USING btree (user_id, event_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: toto
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: toto
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: payments fk_rails_081dc04a02; Type: FK CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_rails_081dc04a02 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: events fk_rails_0cb5590091; Type: FK CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_0cb5590091 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payments fk_rails_1a5e9ad0e2; Type: FK CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_rails_1a5e9ad0e2 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: attendances fk_rails_777eb7170a; Type: FK CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_rails_777eb7170a FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: attendances fk_rails_77ad02f5c5; Type: FK CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_rails_77ad02f5c5 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payments fk_rails_cbff69b3b3; Type: FK CONSTRAINT; Schema: public; Owner: toto
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_rails_cbff69b3b3 FOREIGN KEY (attendance_id) REFERENCES public.attendances(id);


--
-- PostgreSQL database dump complete
--

