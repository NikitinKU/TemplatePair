--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

-- Started on 2023-04-10 11:08:06

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

--
-- TOC entry 209 (class 1255 OID 90288)
-- Name: check_ins_aft(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_ins_aft() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.tuser == 'postgres' THEN
		INSERT INTO tlog(tinfo) VALUES ('INSERTED');
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_ins_aft() OWNER TO postgres;

--
-- TOC entry 210 (class 1255 OID 90271)
-- Name: check_qprice(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_qprice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.qprice <= 0 THEN 
		RAISE EXCEPTION 'Negative price: %', NEW.qprice;
	ELSE 
		NEW.qprice = NEW.qprice + 100;
		RAISE NOTICE 'Price is OK';
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_qprice() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 82126)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    cid integer NOT NULL,
    cname character varying(45)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 82116)
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    eqid integer NOT NULL,
    eqname character varying(45),
    vprice numeric(12,2),
    cprice numeric(12,2)
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 82111)
-- Name: qitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qitem (
    qid integer NOT NULL,
    eqid integer NOT NULL,
    amnt integer,
    qprice numeric(12,2)
);


ALTER TABLE public.qitem OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 82121)
-- Name: quotations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quotations (
    qid integer NOT NULL,
    qdate date,
    cid integer
);


ALTER TABLE public.quotations OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 90273)
-- Name: test_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_seq
    START WITH 1
    INCREMENT BY 10
    NO MINVALUE
    MAXVALUE 1000000
    CACHE 1;


ALTER TABLE public.test_seq OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 90277)
-- Name: tlog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tlog (
    "tkey " integer NOT NULL,
    ttime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    tuser text DEFAULT CURRENT_USER,
    tinfo text
);


ALTER TABLE public.tlog OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 90275)
-- Name: tlog_tkey _seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."tlog_tkey _seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."tlog_tkey _seq" OWNER TO postgres;

--
-- TOC entry 3041 (class 0 OID 0)
-- Dependencies: 207
-- Name: tlog_tkey _seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."tlog_tkey _seq" OWNED BY public.tlog."tkey ";


--
-- TOC entry 204 (class 1259 OID 90263)
-- Name: v1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v1 AS
 SELECT quotations.qid,
    quotations.qdate,
    qitem.eqid,
    qitem.amnt,
    qitem.qprice,
    ((qitem.amnt)::numeric * qitem.qprice) AS qtotal
   FROM (public.qitem
     JOIN public.quotations ON ((qitem.qid = quotations.qid)));


ALTER TABLE public.v1 OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 90267)
-- Name: v2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v2 AS
 SELECT v1.qid,
    v1.qdate,
    v1.eqid,
    v1.amnt,
    v1.qprice,
    v1.qtotal,
    equipment.eqname,
    equipment.cprice,
    (equipment.cprice * (v1.amnt)::numeric) AS ctotal
   FROM (public.v1
     JOIN public.equipment USING (eqid));


ALTER TABLE public.v2 OWNER TO postgres;

--
-- TOC entry 2879 (class 2604 OID 90280)
-- Name: tlog tkey ; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tlog ALTER COLUMN "tkey " SET DEFAULT nextval('public."tlog_tkey _seq"'::regclass);


--
-- TOC entry 3032 (class 0 OID 82126)
-- Dependencies: 203
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES (100, 'UNN');
INSERT INTO public.customers VALUES (101, 'NNTU');
INSERT INTO public.customers VALUES (102, 'NSLU');
INSERT INTO public.customers VALUES (103, 'NNMA');


--
-- TOC entry 3030 (class 0 OID 82116)
-- Dependencies: 201
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment VALUES (1000, 'HP', 100000.95, 200000.00);
INSERT INTO public.equipment VALUES (1001, 'IBM', 120000.45, 150000.99);
INSERT INTO public.equipment VALUES (1002, 'LENOVO', 80000.00, 100000.00);
INSERT INTO public.equipment VALUES (1003, 'CISCO', 200000.11, 250000.00);


--
-- TOC entry 3029 (class 0 OID 82111)
-- Dependencies: 200
-- Data for Name: qitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.qitem VALUES (1, 1000, 1, 150000.00);
INSERT INTO public.qitem VALUES (1, 1001, 2, 140000.00);
INSERT INTO public.qitem VALUES (2, 1000, 2, 180000.00);
INSERT INTO public.qitem VALUES (2, 1001, 1, 140000.00);
INSERT INTO public.qitem VALUES (2, 1002, 4, 100000.00);
INSERT INTO public.qitem VALUES (3, 1001, 2, 130000.00);
INSERT INTO public.qitem VALUES (3, 1002, 5, 100000.99);
INSERT INTO public.qitem VALUES (4, 1002, 5, 90000.95);
INSERT INTO public.qitem VALUES (1, 1002, 1, 10100.00);


--
-- TOC entry 3031 (class 0 OID 82121)
-- Dependencies: 202
-- Data for Name: quotations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quotations VALUES (1, '2016-03-01', 100);
INSERT INTO public.quotations VALUES (2, '2016-01-10', 101);
INSERT INTO public.quotations VALUES (3, '2016-04-20', 101);
INSERT INTO public.quotations VALUES (4, '2016-02-29', 102);


--
-- TOC entry 3035 (class 0 OID 90277)
-- Dependencies: 208
-- Data for Name: tlog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tlog VALUES (1, '2023-03-27 11:40:15.356799+03', 'postgres', 'Prosto tak!');
INSERT INTO public.tlog VALUES (2, '2023-03-27 11:40:37.19529+03', 'postgres', 'Ne prosto tak!');


--
-- TOC entry 3042 (class 0 OID 0)
-- Dependencies: 206
-- Name: test_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_seq', 51, true);


--
-- TOC entry 3043 (class 0 OID 0)
-- Dependencies: 207
-- Name: tlog_tkey _seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."tlog_tkey _seq"', 2, true);


--
-- TOC entry 2889 (class 2606 OID 82130)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (cid);


--
-- TOC entry 2885 (class 2606 OID 82120)
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (eqid);


--
-- TOC entry 2883 (class 2606 OID 82115)
-- Name: qitem qitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_pkey PRIMARY KEY (qid, eqid);


--
-- TOC entry 2887 (class 2606 OID 82125)
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (qid);


--
-- TOC entry 2891 (class 2606 OID 90282)
-- Name: tlog tlog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tlog
    ADD CONSTRAINT tlog_pkey PRIMARY KEY ("tkey ");


--
-- TOC entry 2895 (class 2620 OID 90272)
-- Name: qitem qprice_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER qprice_trigger BEFORE INSERT OR UPDATE ON public.qitem FOR EACH ROW EXECUTE FUNCTION public.check_qprice();


--
-- TOC entry 2896 (class 2620 OID 90289)
-- Name: tlog trigger_ins_aft; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_ins_aft AFTER INSERT OR UPDATE ON public.tlog FOR EACH ROW EXECUTE FUNCTION public.check_ins_aft();


--
-- TOC entry 2893 (class 2606 OID 90254)
-- Name: qitem qitem_eqid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_eqid_fkey FOREIGN KEY (eqid) REFERENCES public.equipment(eqid) NOT VALID;


--
-- TOC entry 2892 (class 2606 OID 90249)
-- Name: qitem qitem_qid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_qid_fkey FOREIGN KEY (qid) REFERENCES public.quotations(qid) NOT VALID;


--
-- TOC entry 2894 (class 2606 OID 82131)
-- Name: quotations quotations_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_cid_fkey FOREIGN KEY (cid) REFERENCES public.customers(cid) NOT VALID;


-- Completed on 2023-04-10 11:08:07

--
-- PostgreSQL database dump complete
--

