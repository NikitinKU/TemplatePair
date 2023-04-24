PGDMP         	                {         	   Quotation    13.2    13.2 &    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    82057 	   Quotation    DATABASE     h   CREATE DATABASE "Quotation" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "Quotation";
                postgres    false            �            1255    90288    check_ins_aft()    FUNCTION     �   CREATE FUNCTION public.check_ins_aft() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.tuser == 'postgres' THEN
		INSERT INTO tlog(tinfo) VALUES ('INSERTED');
	END IF;
	RETURN NEW;
END;
$$;
 &   DROP FUNCTION public.check_ins_aft();
       public          postgres    false            �            1255    90271    check_qprice()    FUNCTION       CREATE FUNCTION public.check_qprice() RETURNS trigger
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
 %   DROP FUNCTION public.check_qprice();
       public          postgres    false            �            1259    82126 	   customers    TABLE     ]   CREATE TABLE public.customers (
    cid integer NOT NULL,
    cname character varying(45)
);
    DROP TABLE public.customers;
       public         heap    postgres    false            �            1259    82116 	   equipment    TABLE     �   CREATE TABLE public.equipment (
    eqid integer NOT NULL,
    eqname character varying(45),
    vprice numeric(12,2),
    cprice numeric(12,2)
);
    DROP TABLE public.equipment;
       public         heap    postgres    false            �            1259    82111    qitem    TABLE        CREATE TABLE public.qitem (
    qid integer NOT NULL,
    eqid integer NOT NULL,
    amnt integer,
    qprice numeric(12,2)
);
    DROP TABLE public.qitem;
       public         heap    postgres    false            �            1259    82121 
   quotations    TABLE     o   CREATE TABLE public.quotations (
    qid integer NOT NULL,
    qdate date,
    cid integer,
    aid integer
);
    DROP TABLE public.quotations;
       public         heap    postgres    false            �            1259    98475    sagents    TABLE     �   CREATE TABLE public.sagents (
    aid integer NOT NULL,
    afname character varying(45),
    asname character varying(45),
    apercent integer
);
    DROP TABLE public.sagents;
       public         heap    postgres    false            �            1259    90273    test_seq    SEQUENCE     w   CREATE SEQUENCE public.test_seq
    START WITH 1
    INCREMENT BY 10
    NO MINVALUE
    MAXVALUE 1000000
    CACHE 1;
    DROP SEQUENCE public.test_seq;
       public          postgres    false            �            1259    90277    tlog    TABLE     �   CREATE TABLE public.tlog (
    "tkey " integer NOT NULL,
    ttime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    tuser text DEFAULT CURRENT_USER,
    tinfo text
);
    DROP TABLE public.tlog;
       public         heap    postgres    false            �            1259    90275    tlog_tkey _seq    SEQUENCE     �   CREATE SEQUENCE public."tlog_tkey _seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."tlog_tkey _seq";
       public          postgres    false    208            �           0    0    tlog_tkey _seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."tlog_tkey _seq" OWNED BY public.tlog."tkey ";
          public          postgres    false    207            �            1259    90263    v1    VIEW       CREATE VIEW public.v1 AS
 SELECT quotations.qid,
    quotations.qdate,
    qitem.eqid,
    qitem.amnt,
    qitem.qprice,
    ((qitem.amnt)::numeric * qitem.qprice) AS qtotal
   FROM (public.qitem
     JOIN public.quotations ON ((qitem.qid = quotations.qid)));
    DROP VIEW public.v1;
       public          postgres    false    202    202    200    200    200    200            �            1259    90267    v2    VIEW       CREATE VIEW public.v2 AS
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
    DROP VIEW public.v2;
       public          postgres    false    204    201    201    201    204    204    204    204    204            C           2604    90280 
   tlog tkey     DEFAULT     l   ALTER TABLE ONLY public.tlog ALTER COLUMN "tkey " SET DEFAULT nextval('public."tlog_tkey _seq"'::regclass);
 ;   ALTER TABLE public.tlog ALTER COLUMN "tkey " DROP DEFAULT;
       public          postgres    false    207    208    208            �          0    82126 	   customers 
   TABLE DATA                 public          postgres    false    203   �)       �          0    82116 	   equipment 
   TABLE DATA                 public          postgres    false    201   R*       �          0    82111    qitem 
   TABLE DATA                 public          postgres    false    200   �*       �          0    82121 
   quotations 
   TABLE DATA                 public          postgres    false    202   ~+       �          0    98475    sagents 
   TABLE DATA                 public          postgres    false    209    ,       �          0    90277    tlog 
   TABLE DATA                 public          postgres    false    208   �,       �           0    0    test_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('public.test_seq', 51, true);
          public          postgres    false    206            �           0    0    tlog_tkey _seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public."tlog_tkey _seq"', 2, true);
          public          postgres    false    207            M           2606    82130    customers customers_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (cid);
 B   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pkey;
       public            postgres    false    203            I           2606    82120    equipment equipment_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (eqid);
 B   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_pkey;
       public            postgres    false    201            G           2606    82115    qitem qitem_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_pkey PRIMARY KEY (qid, eqid);
 :   ALTER TABLE ONLY public.qitem DROP CONSTRAINT qitem_pkey;
       public            postgres    false    200    200            K           2606    82125    quotations quotations_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (qid);
 D   ALTER TABLE ONLY public.quotations DROP CONSTRAINT quotations_pkey;
       public            postgres    false    202            Q           2606    98479    sagents sagents_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.sagents
    ADD CONSTRAINT sagents_pkey PRIMARY KEY (aid);
 >   ALTER TABLE ONLY public.sagents DROP CONSTRAINT sagents_pkey;
       public            postgres    false    209            O           2606    90282    tlog tlog_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.tlog
    ADD CONSTRAINT tlog_pkey PRIMARY KEY ("tkey ");
 8   ALTER TABLE ONLY public.tlog DROP CONSTRAINT tlog_pkey;
       public            postgres    false    208            V           2620    90272    qitem qprice_trigger    TRIGGER     {   CREATE TRIGGER qprice_trigger BEFORE INSERT OR UPDATE ON public.qitem FOR EACH ROW EXECUTE FUNCTION public.check_qprice();
 -   DROP TRIGGER qprice_trigger ON public.qitem;
       public          postgres    false    200    211            W           2620    90289    tlog trigger_ins_aft    TRIGGER     {   CREATE TRIGGER trigger_ins_aft AFTER INSERT OR UPDATE ON public.tlog FOR EACH ROW EXECUTE FUNCTION public.check_ins_aft();
 -   DROP TRIGGER trigger_ins_aft ON public.tlog;
       public          postgres    false    208    210            S           2606    90254    qitem qitem_eqid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_eqid_fkey FOREIGN KEY (eqid) REFERENCES public.equipment(eqid) NOT VALID;
 ?   ALTER TABLE ONLY public.qitem DROP CONSTRAINT qitem_eqid_fkey;
       public          postgres    false    200    201    2889            R           2606    90249    qitem qitem_qid_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_qid_fkey FOREIGN KEY (qid) REFERENCES public.quotations(qid) NOT VALID;
 >   ALTER TABLE ONLY public.qitem DROP CONSTRAINT qitem_qid_fkey;
       public          postgres    false    202    200    2891            U           2606    98480    quotations quotations_aid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_aid_fkey FOREIGN KEY (aid) REFERENCES public.sagents(aid) NOT VALID;
 H   ALTER TABLE ONLY public.quotations DROP CONSTRAINT quotations_aid_fkey;
       public          postgres    false    202    2897    209            T           2606    82131    quotations quotations_cid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_cid_fkey FOREIGN KEY (cid) REFERENCES public.customers(cid) NOT VALID;
 H   ALTER TABLE ONLY public.quotations DROP CONSTRAINT quotations_cid_fkey;
       public          postgres    false    203    202    2893            �   W   x���v
Q���W((M��L�K.-.��M-*Vs�	uV�040�QP��S״��$N�!P��_H(	Z�@Z�}H�b������ ��;�      �   �   x���v
Q���W((M��L�K-,�,�M�+Qs�	uV�0400�QP�P�Q ��,Mu� LMk.O"�1����2�]�h��)�LK2�����4����Hr�1�(g�`g�IP?�id�0�� �L      �   �   x���v
Q���W((M��L�+�,I�Us�	uV�0�Q0400 �@d
d�hZsy�H&$h4��bX����T�m�&���h��Gc�5u��m��$F�	�FK�>S�c�6�0�rq ��Q      �   r   x���v
Q���W((M��L�+,�/I,���+Vs�	uV�0�QP7204�50�50T�Q040�Q���Ѵ��$�#����`#I4�n���yF���0�5�a7�� �eHd      �   �   x���v
Q���W((M��L�+NLO�+)Vs�	uV�0400�QPw�I�PҎ9I�E%�e��@����5�'Q�5����W��q�I-.��b@�)�@��%E 3��RRs�3�s�M0��#�\\ �Pi      �   |   x���v
Q���W((M��L�+��OWs�	uV�0�QP7202�50�52W04�21�24�3653���60V*(�/.I/J-����|���lEuMk.O�a3��\������~�
�6pq 33�     