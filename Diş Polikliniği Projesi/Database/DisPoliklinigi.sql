PGDMP         -                z            DisPoliklinigi    15.0    15.0 i    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ?           1262    16536    DisPoliklinigi    DATABASE     ?   CREATE DATABASE "DisPoliklinigi" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Turkish_Turkey.1254';
     DROP DATABASE "DisPoliklinigi";
                postgres    false            ?            1255    16951    discidecalisanelemansayisi()    FUNCTION     b  CREATE FUNCTION public.discidecalisanelemansayisi() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
doktor INT;
asistan INT;
teknisyen INT;

BEGIN
    doktor := (SELECT COUNT(*) FROM "Doktor");
    asistan := (SELECT COUNT(*) FROM "Asistan");
    teknisyen := (SELECT COUNT(*) FROM "Teknisyen");



    RETURN (doktor+asistan+teknisyen);
END;
$$;
 3   DROP FUNCTION public.discidecalisanelemansayisi();
       public          postgres    false            ?            1255    17013    kayitEkle()    FUNCTION     ?   CREATE FUNCTION public."kayitEkle"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."ad" = UPPER(NEW."ad"); 
    NEW."soyad" = UPPER(NEW."soyad"); 
    NEW."kisiTuru" = UPPER(NEW."kisiTuru"); 

    

    
    RETURN NEW;
END;
$$;
 $   DROP FUNCTION public."kayitEkle"();
       public          postgres    false            ?            1255    16961    kisiara(integer)    FUNCTION     9  CREATE FUNCTION public.kisiara(aranan integer) RETURNS TABLE(numara integer, adi character varying, soyadi character varying, kisituru character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "kisiNo", "ad", "soyad","kisiTuru" FROM "Kisi"
                 WHERE "kisiNo" = aranan;
END;
$$;
 .   DROP FUNCTION public.kisiara(aranan integer);
       public          postgres    false            ?            1255    17017 
   kucukYap()    FUNCTION     ?   CREATE FUNCTION public."kucukYap"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."email" = LOWER(NEW."email"); 
    NEW."email" = TRIM(NEW."email"); 
    
    RETURN NEW;
END;
$$;
 #   DROP FUNCTION public."kucukYap"();
       public          postgres    false            ?            1255    17002    maasDegisikligi1()    FUNCTION     h  CREATE FUNCTION public."maasDegisikligi1"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."maas" <> OLD."maas" THEN
        INSERT INTO "MaasDegisikligi"("ad","soyad" ,"eskiMaas", "yeniMaas", "degisiklikTarihi")
        VALUES(OLD."ad",OLD."soyad", OLD."maas", NEW."maas", CURRENT_TIMESTAMP::TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$;
 +   DROP FUNCTION public."maasDegisikligi1"();
       public          postgres    false            ?            1255    17015    terstenYaz()    FUNCTION     ?   CREATE FUNCTION public."terstenYaz"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."diplomaNo" = REVERSE(NEW."diplomaNo"); 
    
    
    RETURN NEW;
END;
$$;
 %   DROP FUNCTION public."terstenYaz"();
       public          postgres    false            ?            1255    16959    tumkayitlar()    FUNCTION     w  CREATE FUNCTION public.tumkayitlar() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    eleman "Kisi"%ROWTYPE; 
    sonuc TEXT;
BEGIN
    sonuc := '';
    FOR eleman IN SELECT * FROM "Kisi" LOOP
        sonuc := sonuc || eleman."ad" || E'\t' || eleman."soyad" || E'\t'  || eleman."yas" || E'\t'  || eleman."kisiTuru" || E'\r\n';
    END LOOP;
    RETURN sonuc;
END;
$$;
 $   DROP FUNCTION public.tumkayitlar();
       public          postgres    false            ?            1255    16949    zamlimaas(double precision)    FUNCTION     ?   CREATE FUNCTION public.zamlimaas(mevcutmaas double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$ 
BEGIN
    RETURN mevcutMaas + (mevcutMaas/5);
END;
$$;
 =   DROP FUNCTION public.zamlimaas(mevcutmaas double precision);
       public          postgres    false            ?            1259    16891 	   AracGerec    TABLE     ?   CREATE TABLE public."AracGerec" (
    "agNo" integer NOT NULL,
    "agAdi" character varying(20) NOT NULL,
    "kullananKisi" character varying(10) NOT NULL,
    "teknisyenNo" integer,
    "doktorNo" integer
);
    DROP TABLE public."AracGerec";
       public         heap    postgres    false            ?            1259    16839    Asistan    TABLE     \   CREATE TABLE public."Asistan" (
    "asistanNo" integer NOT NULL,
    "doktorNo" integer
);
    DROP TABLE public."Asistan";
       public         heap    postgres    false            ?            1259    16537    DisPoliklinigi    TABLE     ?   CREATE TABLE public."DisPoliklinigi" (
    "poliklinikNo" integer NOT NULL,
    "poliklinikAdi" character(40) NOT NULL,
    "elemanSayisi" integer NOT NULL,
    CONSTRAINT "elemanSayisiCheck" CHECK (("elemanSayisi" >= 0))
);
 $   DROP TABLE public."DisPoliklinigi";
       public         heap    postgres    false            ?            1259    16817    Doktor    TABLE     ?   CREATE TABLE public."Doktor" (
    "doktorNo" integer NOT NULL,
    "sertifikaSayisi" integer DEFAULT 0,
    "diplomaNo" character(10) NOT NULL,
    "unitNo" integer NOT NULL,
    CONSTRAINT "sertifikaSayisiCheck" CHECK (("sertifikaSayisi" >= 0))
);
    DROP TABLE public."Doktor";
       public         heap    postgres    false            ?            1259    16690    Fatura    TABLE     ?   CREATE TABLE public."Fatura" (
    "faturaNo" integer NOT NULL,
    "faturaTarihi" date NOT NULL,
    tutar character(10) NOT NULL
);
    DROP TABLE public."Fatura";
       public         heap    postgres    false            ?            1259    16870    Hasta    TABLE     ?   CREATE TABLE public."Hasta" (
    "hastaNo" integer NOT NULL,
    "agriSiddeti" character varying(20) DEFAULT 'Ağrısı Yok'::character varying,
    "randevuNo" integer,
    "doktorNo" integer
);
    DROP TABLE public."Hasta";
       public         heap    postgres    false            ?            1259    16623    Il    TABLE     s   CREATE TABLE public."Il" (
    "ilNo" character varying(5) NOT NULL,
    "ilAdi" character varying(15) NOT NULL
);
    DROP TABLE public."Il";
       public         heap    postgres    false            ?            1259    16635    Ilce    TABLE     ?   CREATE TABLE public."Ilce" (
    "ilceNo" character varying(5) NOT NULL,
    "ilceAdi" character varying(15) NOT NULL,
    il character varying(5)
);
    DROP TABLE public."Ilce";
       public         heap    postgres    false            ?            1259    16645    IletisimBilgileri    TABLE     ?   CREATE TABLE public."IletisimBilgileri" (
    no integer NOT NULL,
    telefon character varying(20) NOT NULL,
    adres character varying(100) NOT NULL,
    "ilceNo" character varying,
    "kisiNo" integer,
    email character(30) NOT NULL
);
 '   DROP TABLE public."IletisimBilgileri";
       public         heap    postgres    false            ?            1259    16918    Kase    TABLE     l   CREATE TABLE public."Kase" (
    "kaseNo" integer NOT NULL,
    "kaseAdi" character varying(20) NOT NULL
);
    DROP TABLE public."Kase";
       public         heap    postgres    false            ?            1259    16612    Kisi    TABLE     ?   CREATE TABLE public."Kisi" (
    "kisiNo" integer NOT NULL,
    ad character varying(15) NOT NULL,
    soyad character varying(15) NOT NULL,
    yas character(5) NOT NULL,
    "kisiTuru" character varying(20),
    "poliklinikNo" integer,
    maas real
);
    DROP TABLE public."Kisi";
       public         heap    postgres    false            ?            1259    16611    Kisi_kisiNo_seq    SEQUENCE     ?   CREATE SEQUENCE public."Kisi_kisiNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."Kisi_kisiNo_seq";
       public          postgres    false    219            ?           0    0    Kisi_kisiNo_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Kisi_kisiNo_seq" OWNED BY public."Kisi"."kisiNo";
          public          postgres    false    218            ?            1259    16586    Klinik    TABLE     ?   CREATE TABLE public."Klinik" (
    "klinikNo" integer NOT NULL,
    "unitNo" integer,
    "poliklinikNo" integer,
    "klinikAdi" character(15)
);
    DROP TABLE public."Klinik";
       public         heap    postgres    false            ?            1259    16601    Laboratuvar    TABLE     ?   CREATE TABLE public."Laboratuvar" (
    "labNo" integer NOT NULL,
    "labAdi" character varying(30) NOT NULL,
    "poliklinikNo" integer NOT NULL
);
 !   DROP TABLE public."Laboratuvar";
       public         heap    postgres    false            ?            1259    16963    MaasDegisikligi    TABLE     ?   CREATE TABLE public."MaasDegisikligi" (
    "Id" integer NOT NULL,
    ad character(15) NOT NULL,
    "eskiMaas" real NOT NULL,
    "yeniMaas" real NOT NULL,
    "degisiklikTarihi" timestamp without time zone NOT NULL,
    soyad character(15) NOT NULL
);
 %   DROP TABLE public."MaasDegisikligi";
       public         heap    postgres    false            ?            1259    16962    MaasDegisikligi_Id_seq    SEQUENCE     ?   CREATE SEQUENCE public."MaasDegisikligi_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."MaasDegisikligi_Id_seq";
       public          postgres    false    234            ?           0    0    MaasDegisikligi_Id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."MaasDegisikligi_Id_seq" OWNED BY public."MaasDegisikligi"."Id";
          public          postgres    false    233            ?            1259    16812    Randevu    TABLE     ?   CREATE TABLE public."Randevu" (
    "randevuNo" integer NOT NULL,
    "randevuTarihi" date NOT NULL,
    "randevuSaati" character(10) NOT NULL
);
    DROP TABLE public."Randevu";
       public         heap    postgres    false            ?            1259    16854    Recete    TABLE     ?   CREATE TABLE public."Recete" (
    "receteNo" integer NOT NULL,
    "receteTuru" character(20) DEFAULT 'Normal Reçete'::bpchar,
    "kaseNo" integer,
    "doktorNo" integer
);
    DROP TABLE public."Recete";
       public         heap    postgres    false            ?            1259    16796    Siparis    TABLE     ?   CREATE TABLE public."Siparis" (
    "siparisNo" integer NOT NULL,
    "siparisTarihi" date NOT NULL,
    "faturaNo" integer NOT NULL,
    "teknisyenNo" integer NOT NULL,
    islem character(20) NOT NULL
);
    DROP TABLE public."Siparis";
       public         heap    postgres    false            ?            1259    16781 	   Teknisyen    TABLE     ]   CREATE TABLE public."Teknisyen" (
    "teknisyenNo" integer NOT NULL,
    "labNo" integer
);
    DROP TABLE public."Teknisyen";
       public         heap    postgres    false            ?            1259    16548    Unit    TABLE     ?   CREATE TABLE public."Unit" (
    "unitNo" integer NOT NULL,
    "aletSayisi" integer NOT NULL,
    renk character varying(15) DEFAULT 'Gri'::character varying,
    "unitAdi" character(15),
    CONSTRAINT "aletSayisiCheck" CHECK (("aletSayisi" >= 0))
);
    DROP TABLE public."Unit";
       public         heap    postgres    false            ?           2604    16615    Kisi kisiNo    DEFAULT     p   ALTER TABLE ONLY public."Kisi" ALTER COLUMN "kisiNo" SET DEFAULT nextval('public."Kisi_kisiNo_seq"'::regclass);
 >   ALTER TABLE public."Kisi" ALTER COLUMN "kisiNo" DROP DEFAULT;
       public          postgres    false    219    218    219            ?           2604    16966    MaasDegisikligi Id    DEFAULT     ~   ALTER TABLE ONLY public."MaasDegisikligi" ALTER COLUMN "Id" SET DEFAULT nextval('public."MaasDegisikligi_Id_seq"'::regclass);
 E   ALTER TABLE public."MaasDegisikligi" ALTER COLUMN "Id" DROP DEFAULT;
       public          postgres    false    234    233    234            ?          0    16891 	   AracGerec 
   TABLE DATA           a   COPY public."AracGerec" ("agNo", "agAdi", "kullananKisi", "teknisyenNo", "doktorNo") FROM stdin;
    public          postgres    false    231   ?       ?          0    16839    Asistan 
   TABLE DATA           <   COPY public."Asistan" ("asistanNo", "doktorNo") FROM stdin;
    public          postgres    false    228   ??       ?          0    16537    DisPoliklinigi 
   TABLE DATA           [   COPY public."DisPoliklinigi" ("poliklinikNo", "poliklinikAdi", "elemanSayisi") FROM stdin;
    public          postgres    false    214   ڃ       ?          0    16817    Doktor 
   TABLE DATA           X   COPY public."Doktor" ("doktorNo", "sertifikaSayisi", "diplomaNo", "unitNo") FROM stdin;
    public          postgres    false    227   ?       ?          0    16690    Fatura 
   TABLE DATA           E   COPY public."Fatura" ("faturaNo", "faturaTarihi", tutar) FROM stdin;
    public          postgres    false    223   K?       ?          0    16870    Hasta 
   TABLE DATA           T   COPY public."Hasta" ("hastaNo", "agriSiddeti", "randevuNo", "doktorNo") FROM stdin;
    public          postgres    false    230   ??       ?          0    16623    Il 
   TABLE DATA           /   COPY public."Il" ("ilNo", "ilAdi") FROM stdin;
    public          postgres    false    220    ?       ?          0    16635    Ilce 
   TABLE DATA           9   COPY public."Ilce" ("ilceNo", "ilceAdi", il) FROM stdin;
    public          postgres    false    221   ??       ?          0    16645    IletisimBilgileri 
   TABLE DATA           \   COPY public."IletisimBilgileri" (no, telefon, adres, "ilceNo", "kisiNo", email) FROM stdin;
    public          postgres    false    222   ?       ?          0    16918    Kase 
   TABLE DATA           5   COPY public."Kase" ("kaseNo", "kaseAdi") FROM stdin;
    public          postgres    false    232   ??       ?          0    16612    Kisi 
   TABLE DATA           \   COPY public."Kisi" ("kisiNo", ad, soyad, yas, "kisiTuru", "poliklinikNo", maas) FROM stdin;
    public          postgres    false    219   >?       ?          0    16586    Klinik 
   TABLE DATA           U   COPY public."Klinik" ("klinikNo", "unitNo", "poliklinikNo", "klinikAdi") FROM stdin;
    public          postgres    false    216   ??       ?          0    16601    Laboratuvar 
   TABLE DATA           J   COPY public."Laboratuvar" ("labNo", "labAdi", "poliklinikNo") FROM stdin;
    public          postgres    false    217   ??       ?          0    16963    MaasDegisikligi 
   TABLE DATA           h   COPY public."MaasDegisikligi" ("Id", ad, "eskiMaas", "yeniMaas", "degisiklikTarihi", soyad) FROM stdin;
    public          postgres    false    234   ?       ?          0    16812    Randevu 
   TABLE DATA           Q   COPY public."Randevu" ("randevuNo", "randevuTarihi", "randevuSaati") FROM stdin;
    public          postgres    false    226   v?       ?          0    16854    Recete 
   TABLE DATA           R   COPY public."Recete" ("receteNo", "receteTuru", "kaseNo", "doktorNo") FROM stdin;
    public          postgres    false    229   ??       ?          0    16796    Siparis 
   TABLE DATA           c   COPY public."Siparis" ("siparisNo", "siparisTarihi", "faturaNo", "teknisyenNo", islem) FROM stdin;
    public          postgres    false    225   H?       ?          0    16781 	   Teknisyen 
   TABLE DATA           =   COPY public."Teknisyen" ("teknisyenNo", "labNo") FROM stdin;
    public          postgres    false    224   Ԍ       ?          0    16548    Unit 
   TABLE DATA           I   COPY public."Unit" ("unitNo", "aletSayisi", renk, "unitAdi") FROM stdin;
    public          postgres    false    215   ??       ?           0    0    Kisi_kisiNo_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Kisi_kisiNo_seq"', 29, true);
          public          postgres    false    218            ?           0    0    MaasDegisikligi_Id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."MaasDegisikligi_Id_seq"', 2, true);
          public          postgres    false    233            ?           2606    16843    Asistan AsistanPK 
   CONSTRAINT     \   ALTER TABLE ONLY public."Asistan"
    ADD CONSTRAINT "AsistanPK" PRIMARY KEY ("asistanNo");
 ?   ALTER TABLE ONLY public."Asistan" DROP CONSTRAINT "AsistanPK";
       public            postgres    false    228            ?           2606    16823    Doktor DoktorPK 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Doktor"
    ADD CONSTRAINT "DoktorPK" PRIMARY KEY ("doktorNo");
 =   ALTER TABLE ONLY public."Doktor" DROP CONSTRAINT "DoktorPK";
       public            postgres    false    227            ?           2606    16968    MaasDegisikligi PK 
   CONSTRAINT     V   ALTER TABLE ONLY public."MaasDegisikligi"
    ADD CONSTRAINT "PK" PRIMARY KEY ("Id");
 @   ALTER TABLE ONLY public."MaasDegisikligi" DROP CONSTRAINT "PK";
       public            postgres    false    234            ?           2606    16924    AracGerec agNoPK 
   CONSTRAINT     V   ALTER TABLE ONLY public."AracGerec"
    ADD CONSTRAINT "agNoPK" PRIMARY KEY ("agNo");
 >   ALTER TABLE ONLY public."AracGerec" DROP CONSTRAINT "agNoPK";
       public            postgres    false    231            ?           2606    16694    Fatura faturaNoPK 
   CONSTRAINT     [   ALTER TABLE ONLY public."Fatura"
    ADD CONSTRAINT "faturaNoPK" PRIMARY KEY ("faturaNo");
 ?   ALTER TABLE ONLY public."Fatura" DROP CONSTRAINT "faturaNoPK";
       public            postgres    false    223            ?           2606    16875    Hasta hastaNoPK 
   CONSTRAINT     X   ALTER TABLE ONLY public."Hasta"
    ADD CONSTRAINT "hastaNoPK" PRIMARY KEY ("hastaNo");
 =   ALTER TABLE ONLY public."Hasta" DROP CONSTRAINT "hastaNoPK";
       public            postgres    false    230            ?           2606    16629    Il ilAdiUnique 
   CONSTRAINT     P   ALTER TABLE ONLY public."Il"
    ADD CONSTRAINT "ilAdiUnique" UNIQUE ("ilAdi");
 <   ALTER TABLE ONLY public."Il" DROP CONSTRAINT "ilAdiUnique";
       public            postgres    false    220            ?           2606    16627 
   Il ilNoPK1 
   CONSTRAINT     P   ALTER TABLE ONLY public."Il"
    ADD CONSTRAINT "ilNoPK1" PRIMARY KEY ("ilNo");
 8   ALTER TABLE ONLY public."Il" DROP CONSTRAINT "ilNoPK1";
       public            postgres    false    220            ?           2606    16639    Ilce ilceNoPK1 
   CONSTRAINT     V   ALTER TABLE ONLY public."Ilce"
    ADD CONSTRAINT "ilceNoPK1" PRIMARY KEY ("ilceNo");
 <   ALTER TABLE ONLY public."Ilce" DROP CONSTRAINT "ilceNoPK1";
       public            postgres    false    221            ?           2606    16922    Kase kaseNoPK 
   CONSTRAINT     U   ALTER TABLE ONLY public."Kase"
    ADD CONSTRAINT "kaseNoPK" PRIMARY KEY ("kaseNo");
 ;   ALTER TABLE ONLY public."Kase" DROP CONSTRAINT "kaseNoPK";
       public            postgres    false    232            ?           2606    16617    Kisi kisiNoPK 
   CONSTRAINT     U   ALTER TABLE ONLY public."Kisi"
    ADD CONSTRAINT "kisiNoPK" PRIMARY KEY ("kisiNo");
 ;   ALTER TABLE ONLY public."Kisi" DROP CONSTRAINT "kisiNoPK";
       public            postgres    false    219            ?           2606    16590    Klinik klinikNoPK 
   CONSTRAINT     [   ALTER TABLE ONLY public."Klinik"
    ADD CONSTRAINT "klinikNoPK" PRIMARY KEY ("klinikNo");
 ?   ALTER TABLE ONLY public."Klinik" DROP CONSTRAINT "klinikNoPK";
       public            postgres    false    216            ?           2606    16605    Laboratuvar labNoPK 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Laboratuvar"
    ADD CONSTRAINT "labNoPK" PRIMARY KEY ("labNo");
 A   ALTER TABLE ONLY public."Laboratuvar" DROP CONSTRAINT "labNoPK";
       public            postgres    false    217            ?           2606    16651    IletisimBilgileri noPK 
   CONSTRAINT     X   ALTER TABLE ONLY public."IletisimBilgileri"
    ADD CONSTRAINT "noPK" PRIMARY KEY (no);
 D   ALTER TABLE ONLY public."IletisimBilgileri" DROP CONSTRAINT "noPK";
       public            postgres    false    222            ?           2606    16907 "   DisPoliklinigi poliklinikAdiUnique 
   CONSTRAINT     l   ALTER TABLE ONLY public."DisPoliklinigi"
    ADD CONSTRAINT "poliklinikAdiUnique" UNIQUE ("poliklinikAdi");
 P   ALTER TABLE ONLY public."DisPoliklinigi" DROP CONSTRAINT "poliklinikAdiUnique";
       public            postgres    false    214            ?           2606    16542    DisPoliklinigi poliklinikPK 
   CONSTRAINT     i   ALTER TABLE ONLY public."DisPoliklinigi"
    ADD CONSTRAINT "poliklinikPK" PRIMARY KEY ("poliklinikNo");
 I   ALTER TABLE ONLY public."DisPoliklinigi" DROP CONSTRAINT "poliklinikPK";
       public            postgres    false    214            ?           2606    16816    Randevu randevuNoPK 
   CONSTRAINT     ^   ALTER TABLE ONLY public."Randevu"
    ADD CONSTRAINT "randevuNoPK" PRIMARY KEY ("randevuNo");
 A   ALTER TABLE ONLY public."Randevu" DROP CONSTRAINT "randevuNoPK";
       public            postgres    false    226            ?           2606    16859    Recete receteNoPK 
   CONSTRAINT     [   ALTER TABLE ONLY public."Recete"
    ADD CONSTRAINT "receteNoPK" PRIMARY KEY ("receteNo");
 ?   ALTER TABLE ONLY public."Recete" DROP CONSTRAINT "receteNoPK";
       public            postgres    false    229            ?           2606    16800    Siparis siparisNoPK 
   CONSTRAINT     ^   ALTER TABLE ONLY public."Siparis"
    ADD CONSTRAINT "siparisNoPK" PRIMARY KEY ("siparisNo");
 A   ALTER TABLE ONLY public."Siparis" DROP CONSTRAINT "siparisNoPK";
       public            postgres    false    225            ?           2606    16785    Teknisyen teknisyenNoPK 
   CONSTRAINT     d   ALTER TABLE ONLY public."Teknisyen"
    ADD CONSTRAINT "teknisyenNoPK" PRIMARY KEY ("teknisyenNo");
 E   ALTER TABLE ONLY public."Teknisyen" DROP CONSTRAINT "teknisyenNoPK";
       public            postgres    false    224            ?           2606    16653    IletisimBilgileri telefonUnique 
   CONSTRAINT     a   ALTER TABLE ONLY public."IletisimBilgileri"
    ADD CONSTRAINT "telefonUnique" UNIQUE (telefon);
 M   ALTER TABLE ONLY public."IletisimBilgileri" DROP CONSTRAINT "telefonUnique";
       public            postgres    false    222            ?           2606    16554    Unit unitNoPK 
   CONSTRAINT     U   ALTER TABLE ONLY public."Unit"
    ADD CONSTRAINT "unitNoPK" PRIMARY KEY ("unitNo");
 ;   ALTER TABLE ONLY public."Unit" DROP CONSTRAINT "unitNoPK";
       public            postgres    false    215                        2620    17014    Kisi kayitekle    TRIGGER     v   CREATE TRIGGER kayitekle BEFORE INSERT OR UPDATE ON public."Kisi" FOR EACH ROW EXECUTE FUNCTION public."kayitEkle"();
 )   DROP TRIGGER kayitekle ON public."Kisi";
       public          postgres    false    219    240                       2620    17018    IletisimBilgileri kucukyap    TRIGGER     ?   CREATE TRIGGER kucukyap BEFORE INSERT OR UPDATE ON public."IletisimBilgileri" FOR EACH ROW EXECUTE FUNCTION public."kucukYap"();
 5   DROP TRIGGER kucukyap ON public."IletisimBilgileri";
       public          postgres    false    242    222                       2620    17003    Kisi maasDegistiginde    TRIGGER     |   CREATE TRIGGER "maasDegistiginde" BEFORE UPDATE ON public."Kisi" FOR EACH ROW EXECUTE FUNCTION public."maasDegisikligi1"();
 2   DROP TRIGGER "maasDegistiginde" ON public."Kisi";
       public          postgres    false    219    239                       2620    17016    Doktor tersyaz    TRIGGER     w   CREATE TRIGGER tersyaz BEFORE INSERT OR UPDATE ON public."Doktor" FOR EACH ROW EXECUTE FUNCTION public."terstenYaz"();
 )   DROP TRIGGER tersyaz ON public."Doktor";
       public          postgres    false    227    241            ?           2606    16896    AracGerec AracGerecFK1    FK CONSTRAINT     ?   ALTER TABLE ONLY public."AracGerec"
    ADD CONSTRAINT "AracGerecFK1" FOREIGN KEY ("teknisyenNo") REFERENCES public."Teknisyen"("teknisyenNo");
 D   ALTER TABLE ONLY public."AracGerec" DROP CONSTRAINT "AracGerecFK1";
       public          postgres    false    224    231    3288            ?           2606    16901    AracGerec AracGerecFK2    FK CONSTRAINT     ?   ALTER TABLE ONLY public."AracGerec"
    ADD CONSTRAINT "AracGerecFK2" FOREIGN KEY ("doktorNo") REFERENCES public."Doktor"("doktorNo");
 D   ALTER TABLE ONLY public."AracGerec" DROP CONSTRAINT "AracGerecFK2";
       public          postgres    false    3294    231    227            ?           2606    16849    Asistan AsistanKisi    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Asistan"
    ADD CONSTRAINT "AsistanKisi" FOREIGN KEY ("asistanNo") REFERENCES public."Kisi"("kisiNo") ON UPDATE CASCADE ON DELETE CASCADE;
 A   ALTER TABLE ONLY public."Asistan" DROP CONSTRAINT "AsistanKisi";
       public          postgres    false    219    3274    228            ?           2606    16824    Doktor DoktorFK1    FK CONSTRAINT     {   ALTER TABLE ONLY public."Doktor"
    ADD CONSTRAINT "DoktorFK1" FOREIGN KEY ("unitNo") REFERENCES public."Unit"("unitNo");
 >   ALTER TABLE ONLY public."Doktor" DROP CONSTRAINT "DoktorFK1";
       public          postgres    false    227    215    3268            ?           2606    16834    Doktor DoktorKisi    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Doktor"
    ADD CONSTRAINT "DoktorKisi" FOREIGN KEY ("doktorNo") REFERENCES public."Kisi"("kisiNo") ON UPDATE CASCADE ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public."Doktor" DROP CONSTRAINT "DoktorKisi";
       public          postgres    false    227    3274    219            ?           2606    16876    Hasta HastaFK1    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Hasta"
    ADD CONSTRAINT "HastaFK1" FOREIGN KEY ("randevuNo") REFERENCES public."Randevu"("randevuNo");
 <   ALTER TABLE ONLY public."Hasta" DROP CONSTRAINT "HastaFK1";
       public          postgres    false    230    3292    226            ?           2606    16881    Hasta HastaFK2    FK CONSTRAINT        ALTER TABLE ONLY public."Hasta"
    ADD CONSTRAINT "HastaFK2" FOREIGN KEY ("doktorNo") REFERENCES public."Doktor"("doktorNo");
 <   ALTER TABLE ONLY public."Hasta" DROP CONSTRAINT "HastaFK2";
       public          postgres    false    227    3294    230            ?           2606    16886    Hasta HastaKisi    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Hasta"
    ADD CONSTRAINT "HastaKisi" FOREIGN KEY ("hastaNo") REFERENCES public."Kisi"("kisiNo") ON UPDATE CASCADE ON DELETE CASCADE;
 =   ALTER TABLE ONLY public."Hasta" DROP CONSTRAINT "HastaKisi";
       public          postgres    false    3274    219    230            ?           2606    16640    Ilce IlceFK1    FK CONSTRAINT     m   ALTER TABLE ONLY public."Ilce"
    ADD CONSTRAINT "IlceFK1" FOREIGN KEY (il) REFERENCES public."Il"("ilNo");
 :   ALTER TABLE ONLY public."Ilce" DROP CONSTRAINT "IlceFK1";
       public          postgres    false    3278    220    221            ?           2606    16654 &   IletisimBilgileri IletisimBilgileriFK1    FK CONSTRAINT     ?   ALTER TABLE ONLY public."IletisimBilgileri"
    ADD CONSTRAINT "IletisimBilgileriFK1" FOREIGN KEY ("ilceNo") REFERENCES public."Ilce"("ilceNo");
 T   ALTER TABLE ONLY public."IletisimBilgileri" DROP CONSTRAINT "IletisimBilgileriFK1";
       public          postgres    false    3280    221    222            ?           2606    16659 &   IletisimBilgileri IletisimBilgileriFK2    FK CONSTRAINT     ?   ALTER TABLE ONLY public."IletisimBilgileri"
    ADD CONSTRAINT "IletisimBilgileriFK2" FOREIGN KEY ("kisiNo") REFERENCES public."Kisi"("kisiNo");
 T   ALTER TABLE ONLY public."IletisimBilgileri" DROP CONSTRAINT "IletisimBilgileriFK2";
       public          postgres    false    3274    222    219            ?           2606    16618    Kisi KisiFK1    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Kisi"
    ADD CONSTRAINT "KisiFK1" FOREIGN KEY ("poliklinikNo") REFERENCES public."DisPoliklinigi"("poliklinikNo");
 :   ALTER TABLE ONLY public."Kisi" DROP CONSTRAINT "KisiFK1";
       public          postgres    false    219    3266    214            ?           2606    16606    Laboratuvar LaboratuvarFK1    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Laboratuvar"
    ADD CONSTRAINT "LaboratuvarFK1" FOREIGN KEY ("poliklinikNo") REFERENCES public."DisPoliklinigi"("poliklinikNo");
 H   ALTER TABLE ONLY public."Laboratuvar" DROP CONSTRAINT "LaboratuvarFK1";
       public          postgres    false    3266    217    214            ?           2606    16865    Recete ReceteFK2    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Recete"
    ADD CONSTRAINT "ReceteFK2" FOREIGN KEY ("doktorNo") REFERENCES public."Doktor"("doktorNo");
 >   ALTER TABLE ONLY public."Recete" DROP CONSTRAINT "ReceteFK2";
       public          postgres    false    229    227    3294            ?           2606    16801    Siparis SiparisFK1    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Siparis"
    ADD CONSTRAINT "SiparisFK1" FOREIGN KEY ("faturaNo") REFERENCES public."Fatura"("faturaNo");
 @   ALTER TABLE ONLY public."Siparis" DROP CONSTRAINT "SiparisFK1";
       public          postgres    false    225    223    3286            ?           2606    16806    Siparis SiparisFK2    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Siparis"
    ADD CONSTRAINT "SiparisFK2" FOREIGN KEY ("teknisyenNo") REFERENCES public."Teknisyen"("teknisyenNo");
 @   ALTER TABLE ONLY public."Siparis" DROP CONSTRAINT "SiparisFK2";
       public          postgres    false    224    225    3288            ?           2606    16786    Teknisyen TeknisyenFK1    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Teknisyen"
    ADD CONSTRAINT "TeknisyenFK1" FOREIGN KEY ("labNo") REFERENCES public."Laboratuvar"("labNo");
 D   ALTER TABLE ONLY public."Teknisyen" DROP CONSTRAINT "TeknisyenFK1";
       public          postgres    false    224    3272    217            ?           2606    16791    Teknisyen TeknisyenKisi    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Teknisyen"
    ADD CONSTRAINT "TeknisyenKisi" FOREIGN KEY ("teknisyenNo") REFERENCES public."Kisi"("kisiNo") ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public."Teknisyen" DROP CONSTRAINT "TeknisyenKisi";
       public          postgres    false    224    219    3274            ?           2606    16596    Klinik disPoliklinigiFK2    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Klinik"
    ADD CONSTRAINT "disPoliklinigiFK2" FOREIGN KEY ("poliklinikNo") REFERENCES public."DisPoliklinigi"("poliklinikNo");
 F   ALTER TABLE ONLY public."Klinik" DROP CONSTRAINT "disPoliklinigiFK2";
       public          postgres    false    216    214    3266            ?           2606    16844    Asistan doktorNoFK1    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Asistan"
    ADD CONSTRAINT "doktorNoFK1" FOREIGN KEY ("doktorNo") REFERENCES public."Doktor"("doktorNo");
 A   ALTER TABLE ONLY public."Asistan" DROP CONSTRAINT "doktorNoFK1";
       public          postgres    false    3294    227    228            ?           2606    16591    Klinik unitFK1    FK CONSTRAINT     y   ALTER TABLE ONLY public."Klinik"
    ADD CONSTRAINT "unitFK1" FOREIGN KEY ("unitNo") REFERENCES public."Unit"("unitNo");
 <   ALTER TABLE ONLY public."Klinik" DROP CONSTRAINT "unitFK1";
       public          postgres    false    215    216    3268            ?   ?   x?e?;?0D??Sp??cC???@??Lc	G?l??"9??`??v?泳7g8?18??????????њy?̑????2>?B?]L?*F???'m7?׫A?Α'??ŪU9T?HR??Rkby?$???q???k?yǧ?ڒƼ(??~KD?S?e?      ?      x???4???4?24?4?????? mV      ?      x?3?tI?+	???LU?8͹b???? ??      ?   4   x?3?44"c3?4?2?4?465?0?q?s?s?Z?@??b???? ?}      ?   L   x?=???0?7L???	Q??????G??b?a??B???)๏?ry?p?l??4?D????g{n?????=U?KuC      ?   i   x?34?t<2?????#"??9?8M??9??a?E?f q?????h2 SL???\?fhƛs?q?c3??????(fd?M?)?#C4?M??1z\\\ ??No      ?   Z   x?35?N?-.??25???*??8???D.c?#?K??Js?L?8??RJ??8C??K???8?????L9]??J?Js?b???? Eh?      ?      x???tJ??I-JJ???46???.?)I??s?&??9%G6????r?q?s?ޖ?}x[%?g??X??]??ij?e??X???Y??ij?eՖ?xd>???)?kQRb"???????N#S?=... ?z'U      ?   ?  x?u?Mn?0???)?l?H?🻴H?EP?@?̆?i?0-?ù@/Q W??j?{???#???????{C?<'L?
?@TZj??yv{5??PT??q3???Z?h?f?_?ĵ;؏?Fs??yS?6.???n??E6?????.(?5(?.W??]0BpO???ލ????\ϭ?g????%ɩJT?(??|?????$?? ? ?7?Z??]?·d@?t.ӈ? )?&??s|?PM??F.x[?4?n?=7?ut*???g?????????1%?h??V.???>?dGW???jѺ#got???٭ݿ'{??H?]????????;;?^??\p?Z?MJ?A?7?Z<i5V!?.????s?"M?I????????/@"????ס)ͅ??x??!@r?[????U?T??=?ĭ?|???2?2,??Ӑ????"1(??0?#
J???a6???گ҈????>??e{? ?9????|?or?????I<5??]DS??R?[wp?/"s&?|??Q??,????[??i?? ??1쫹۽7?/??2'?A?~??8ٯ?q?/?7?T	<?OjG[k???/????????i??O?M
??Aߚ?'o?H?m??nM?0d?u Bsƅ??!T??!???>?n&?J?$>??Z?P?a?????t/S??i?yco?G??6ռ??????U?m???dvWdY?Q?H      ?   D   x?3?t)?Sp??LSp?N*?)-?2?f??*D٘?rdcё??\?`???????ʜ?<?=... ش?      ?   f  x?m?1r?0D??)8AƒmJ????@C?F? ?m???¹ G?M*w???N*iFo??w??H??,{???l??8??z???`X?{,?B?BW?,??jD]&ĸ%f?;?Q??.a???df{?Mj???]??y4??,???h?7FU??ȄF?w??&)?U??^???}LlS?Zi?:??a?0*Ȇ=?R??C?:L?Q??H?M?U%?-??SZ?<?}ߋ?i??Y;?|????L	kI??;&)	i?`Q????T??a?K???&?m?r???0?F? ??P!n?/e?UQ????\i?U{?vT{????1b?qZ??)??='?{?,??=????y????F      ?   +   x?3?4B??̼?lC(?2?4???E?9????p?=... ?F?      ?       x?3?tI?+I???IU?IL?4?????? Y?<      ?   G   x?3????KU@ NCNCs id`d?kD?
??V?V&zF???f???G6???Xtdc.TW? ??      ?   a   x?E??	?0г3Ep??_?Y??M (F???1H?L1?7?Z??<{?c:????Ő??pTC?W?p og?1dy?>?]?l???&???r??;??ue#Q      ?   Q   x?3??L=:?3G?(???ԒT(?4?4?2???/?M?QB??s*`?F?f\&03???I??0ӘӜ??F?d? +?      ?   |   x?3?4202?5"NCNCC?#rr?J??T?????H?K???
!???U9?G?g?C ??4?+<ܞ?????d?	?D???i9???S|x?ZS?Z???H??d??2F??? ??2q      ?      x?34?4?????? HO      ?   9   x?3?4?άL??<<'/?$?P???R?E?P	#??1P?????T??1B*F??? ?A'     