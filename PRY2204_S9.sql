-- ============================================================
-- ANFP - EVALUACION FINAL TRANSVERSAL
-- Orden: Borrar - Crear - Restricciones - Poblar - Consultar
-- ============================================================

-- -----------------------------------------------
-- ELIMINACION DE OBJETOS 
-- -----------------------------------------------
DROP TABLE JUGADOR_IDIOMA CASCADE CONSTRAINTS;
DROP TABLE JUGADOR_CLUB CASCADE CONSTRAINTS;
DROP TABLE PERSONAL_PLANTA CASCADE CONSTRAINTS;
DROP TABLE JUGADOR CASCADE CONSTRAINTS;
DROP TABLE TRABAJADOR CASCADE CONSTRAINTS;
DROP TABLE CLUB_FUTBOL CASCADE CONSTRAINTS;
DROP TABLE IDIOMA CASCADE CONSTRAINTS;
DROP TABLE ESCUELA CASCADE CONSTRAINTS;
DROP TABLE ASOCIACION CASCADE CONSTRAINTS;
DROP TABLE NACIONALIDAD CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP SEQUENCE seq_club;

-- ------------------------------------------------
-- CREACION DE TABLAS
-- ------------------------------------------------
CREATE TABLE REGION
    (
     id_region     INTEGER  NOT NULL ,
     nombre_region VARCHAR2 (40)  NOT NULL
    )
;
ALTER TABLE REGION
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region ) ;

CREATE TABLE COMUNA
    (
     id_comuna        INTEGER  NOT NULL ,
     nombre_comuna    VARCHAR2 (30)  NOT NULL ,
     REGION_id_region INTEGER  NOT NULL
    )
;
ALTER TABLE COMUNA
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna, REGION_id_region ) ;

-- IDENTITY: comienza en 210 y se incrementa de 2 en 2
CREATE TABLE NACIONALIDAD
    (
     id_nacion   INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 2) NOT NULL ,
     descripcion VARCHAR2 (30)  NOT NULL
    )
;
ALTER TABLE NACIONALIDAD
    ADD CONSTRAINT NACIONALIDAD_PK PRIMARY KEY ( id_nacion ) ;

CREATE TABLE ASOCIACION
    (
     id_asociacion     INTEGER  NOT NULL ,
     nombre_asociacion VARCHAR2 (60)  NOT NULL ,
     fecha_creacion    DATE  NOT NULL ,
     tipo_asociacion   CHAR (1)  NOT NULL
    )
;
ALTER TABLE ASOCIACION
    ADD CONSTRAINT ASOCIACION_PK PRIMARY KEY ( id_asociacion ) ;

CREATE TABLE ESCUELA
    (
     id_escuela      INTEGER  NOT NULL ,
     nombre_escuela  VARCHAR2 (40)  NOT NULL ,
     capacidad       INTEGER  NOT NULL ,
     fecha_fundacion DATE  NOT NULL
    )
;
ALTER TABLE ESCUELA
    ADD CONSTRAINT ESCUELA_PK PRIMARY KEY ( id_escuela ) ;

CREATE TABLE IDIOMA
    (
     id_idioma     INTEGER  NOT NULL ,
     nombre_idioma VARCHAR2 (30)  NOT NULL
    )
;
ALTER TABLE IDIOMA
    ADD CONSTRAINT IDIOMA_PK PRIMARY KEY ( id_idioma ) ;

CREATE TABLE CLUB_FUTBOL
    (
     id_club         INTEGER  NOT NULL ,
     nombre_club     VARCHAR2 (40)  NOT NULL ,
     patrimonio      NUMBER (12)  NOT NULL ,
     ubicacion_calle VARCHAR2 (60)  NOT NULL ,
     tipo_club       VARCHAR2 (15)  NOT NULL
    )
;
ALTER TABLE CLUB_FUTBOL
    ADD CONSTRAINT CLUB_FUTBOL_PK PRIMARY KEY ( id_club ) ;

CREATE TABLE TRABAJADOR
    (
     cod_inscripcion         INTEGER  NOT NULL ,
     rut                     INTEGER  NOT NULL ,
     dv                      CHAR (1)  NOT NULL ,
     nombres                 VARCHAR2 (40)  NOT NULL ,
     apellidos               VARCHAR2 (40)  NOT NULL ,
     sueldo_base             NUMBER (8)  NOT NULL ,
     fecha_nacimiento        DATE  NOT NULL ,
     genero                  CHAR (1)  NOT NULL ,
     estado_civil            VARCHAR2 (15)  NOT NULL ,
     fono_movil              VARCHAR2 (15)  NOT NULL ,
     direccion               VARCHAR2 (60)  NOT NULL ,
     COMUNA_id_comuna        INTEGER  NOT NULL ,
     NACIONALIDAD_id_nacion  INTEGER  NOT NULL ,
     COMUNA_REGION_id_region INTEGER  NOT NULL
    )
;
ALTER TABLE TRABAJADOR
    ADD CONSTRAINT TRABAJADOR_PK PRIMARY KEY ( cod_inscripcion ) ;

CREATE TABLE JUGADOR
    (
     cod_inscripcion          INTEGER  NOT NULL ,
     puesto                   VARCHAR2 (20)  NOT NULL ,
     premios_acumulados       NUMBER (10) DEFAULT 0 NOT NULL ,
     anio_egreso              INTEGER ,
     ASOCIACION_id_asociacion INTEGER  NOT NULL ,
     ESCUELA_id_escuela       INTEGER
    )
;
ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_PK PRIMARY KEY ( cod_inscripcion ) ;

CREATE TABLE PERSONAL_PLANTA
    (
     cod_inscripcion  INTEGER  NOT NULL ,
     horas_trabajadas INTEGER ,
     valor_hora_extra NUMBER (7)
    )
;
ALTER TABLE PERSONAL_PLANTA
    ADD CONSTRAINT PERSONAL_PLANTA_PK PRIMARY KEY ( cod_inscripcion ) ;

CREATE TABLE JUGADOR_CLUB
    (
     fecha_inicio            DATE  NOT NULL ,
     fecha_termino           DATE ,
     CLUB_FUTBOL_id_club     INTEGER  NOT NULL ,
     JUGADOR_cod_inscripcion INTEGER  NOT NULL
    )
;
ALTER TABLE JUGADOR_CLUB
    ADD CONSTRAINT JUGADOR_CLUB_PK PRIMARY KEY ( fecha_inicio, CLUB_FUTBOL_id_club, JUGADOR_cod_inscripcion ) ;

CREATE TABLE JUGADOR_IDIOMA
    (
     nivel_dominio           VARCHAR2 (20)  NOT NULL ,
     IDIOMA_id_idioma        INTEGER  NOT NULL ,
     JUGADOR_cod_inscripcion INTEGER  NOT NULL
    )
;
ALTER TABLE JUGADOR_IDIOMA
    ADD CONSTRAINT JUGADOR_IDIOMA_PK PRIMARY KEY ( IDIOMA_id_idioma, JUGADOR_cod_inscripcion ) ;

-- ------------------------------------------------------------
-- CLAVES FORANEAS
-- ------------------------------------------------------------
ALTER TABLE COMUNA
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY ( REGION_id_region )
    REFERENCES REGION ( id_region ) ;

ALTER TABLE TRABAJADOR
    ADD CONSTRAINT TRABAJADOR_COMUNA_FK FOREIGN KEY ( COMUNA_id_comuna, COMUNA_REGION_id_region )
    REFERENCES COMUNA ( id_comuna, REGION_id_region ) ;

ALTER TABLE TRABAJADOR
    ADD CONSTRAINT TRABAJADOR_NACIONALIDAD_FK FOREIGN KEY ( NACIONALIDAD_id_nacion )
    REFERENCES NACIONALIDAD ( id_nacion ) ;

ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_TRABAJADOR_FK FOREIGN KEY ( cod_inscripcion )
    REFERENCES TRABAJADOR ( cod_inscripcion ) ;

ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_ASOCIACION_FK FOREIGN KEY ( ASOCIACION_id_asociacion )
    REFERENCES ASOCIACION ( id_asociacion ) ;

ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_ESCUELA_FK FOREIGN KEY ( ESCUELA_id_escuela )
    REFERENCES ESCUELA ( id_escuela ) ;

ALTER TABLE PERSONAL_PLANTA
    ADD CONSTRAINT PERSONAL_PLANTA_TRABAJADOR_FK FOREIGN KEY ( cod_inscripcion )
    REFERENCES TRABAJADOR ( cod_inscripcion ) ;

ALTER TABLE JUGADOR_CLUB
    ADD CONSTRAINT JUGADOR_CLUB_CLUB_FUTBOL_FK FOREIGN KEY ( CLUB_FUTBOL_id_club )
    REFERENCES CLUB_FUTBOL ( id_club ) ;

ALTER TABLE JUGADOR_CLUB
    ADD CONSTRAINT JUGADOR_CLUB_JUGADOR_FK FOREIGN KEY ( JUGADOR_cod_inscripcion )
    REFERENCES JUGADOR ( cod_inscripcion ) ;

ALTER TABLE JUGADOR_IDIOMA
    ADD CONSTRAINT JUGADOR_IDIOMA_IDIOMA_FK FOREIGN KEY ( IDIOMA_id_idioma )
    REFERENCES IDIOMA ( id_idioma ) ;

ALTER TABLE JUGADOR_IDIOMA
    ADD CONSTRAINT JUGADOR_IDIOMA_JUGADOR_FK FOREIGN KEY ( JUGADOR_cod_inscripcion )
    REFERENCES JUGADOR ( cod_inscripcion ) ;

-- ------------------------------------------------------------
-- RESTRICCIONES ADICIONALES (UN y CK)
-- ------------------------------------------------------------
-- El nombre del club debe ser unico
ALTER TABLE CLUB_FUTBOL
    ADD CONSTRAINT CLUB_FUTBOL_UN_NOMBRE UNIQUE ( nombre_club ) ;

-- La fecha de creacion debe ser igual o posterior al 31-12-1980
ALTER TABLE ASOCIACION
    ADD CONSTRAINT ASOCIACION_CK_FECHA
    CHECK ( fecha_creacion >= TO_DATE('31-12-1980','DD-MM-YYYY') ) ;

-- Tipo de asociacion: P (profesional) o A (amateur)
ALTER TABLE ASOCIACION
    ADD CONSTRAINT ASOCIACION_CK_TIPO CHECK ( tipo_asociacion IN ('P','A') ) ;

-- ------------------------------------------------------------
-- SECUENCIA: id_club comienza en 703 y se incrementa de 4 en 4
-- ------------------------------------------------------------
CREATE SEQUENCE seq_club START WITH 703 INCREMENT BY 4;

-- ------------------------------------------------------------
-- POBLAMIENTO (REGION -> COMUNA -> ASOCIACION -> NACIONALIDAD -> CLUB_FUTBOL)
-- ------------------------------------------------------------

-- REGION (las regiones 8 y 16 no vienen en la Figura 2 pero las usa COMUNA)
INSERT INTO REGION (id_region, nombre_region) VALUES (1,  'ARICA Y PARINACOTA Y TARAPACA');
INSERT INTO REGION (id_region, nombre_region) VALUES (2,  'ANTOFAGASTA');
INSERT INTO REGION (id_region, nombre_region) VALUES (3,  'ATACAMA Y COQUIMBO');
INSERT INTO REGION (id_region, nombre_region) VALUES (5,  'VALPARAISO');
INSERT INTO REGION (id_region, nombre_region) VALUES (8,  'BIOBIO');
INSERT INTO REGION (id_region, nombre_region) VALUES (13, 'METROPOLITANA');
INSERT INTO REGION (id_region, nombre_region) VALUES (16, 'NUBLE');

-- COMUNA
INSERT INTO COMUNA (id_comuna, REGION_id_region, nombre_comuna) VALUES (101, 13, 'Santiago');
INSERT INTO COMUNA (id_comuna, REGION_id_region, nombre_comuna) VALUES (102, 5,  'Valparaiso');
INSERT INTO COMUNA (id_comuna, REGION_id_region, nombre_comuna) VALUES (103, 8,  'Concepcion');
INSERT INTO COMUNA (id_comuna, REGION_id_region, nombre_comuna) VALUES (104, 2,  'Antofagasta');
INSERT INTO COMUNA (id_comuna, REGION_id_region, nombre_comuna) VALUES (105, 16, 'Chillan');

-- ASOCIACION
INSERT INTO ASOCIACION VALUES (25, 'Asociación de Fútbol de Santiago',        TO_DATE('15-05-2001','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION VALUES (26, 'Asociación Nacional de Fútbol Amateur',   TO_DATE('10-03-1998','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION VALUES (27, 'Asociación de Fútbol de Valparaiso',      TO_DATE('21-07-1987','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION VALUES (28, 'Asociación de Fútbol de Concepción',      TO_DATE('30-11-1995','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION VALUES (29, 'Asociación de Fútbol de Antofagasta',     TO_DATE('25-06-2003','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION VALUES (30, 'Asociación de Fútbol de Temuco',          TO_DATE('12-01-2010','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION VALUES (31, 'Asociación de Fútbol de Rancagua',        TO_DATE('08-09-1999','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION VALUES (32, 'Asociación de Fútbol de Puerto Montt',    TO_DATE('20-04-2005','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION VALUES (33, 'Asociación de Fútbol de La Serena',       TO_DATE('14-08-2012','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION VALUES (34, 'Asociación de Fútbol de Chillán',         TO_DATE('01-12-2018','DD-MM-YYYY'), 'A');

-- NACIONALIDAD (el identity genera 210, 212, 214, 216, 218)
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Chilena');
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Argentina');
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Peruana');
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Boliviana');
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Brasileña');

-- CLUB_FUTBOL (la secuencia genera 703, 707, 711, 715, 719)
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club.NEXTVAL, 'Colo-Colo',            500000000, 'Av. Marathon 5300',                'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club.NEXTVAL, 'Universidad de Chile', 450000000, 'Av. El Parrón 0931',               'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida Angamos 01606',            'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club.NEXTVAL, 'Huachipato',           220000000, 'Avenida Desiderio García 909',     'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club.NEXTVAL, 'Ñublense',             170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional');

COMMIT;

-- ------------------------------------------------------------
-- INFORME 1: asociaciones profesionales creadas despues del 2000
-- ------------------------------------------------------------
SELECT
    'ID:' || id_asociacion || ' * ' || nombre_asociacion AS "ASOCIACION",
    TO_CHAR(fecha_creacion, 'DD-MM-YYYY')                AS "CREADA",
    tipo_asociacion                                      AS "TIPO"
FROM ASOCIACION
WHERE tipo_asociacion = 'P'
  AND fecha_creacion > TO_DATE('31-12-2000','DD-MM-YYYY')
ORDER BY fecha_creacion DESC;

-- ------------------------------------------------------------
-- INFORME 2: patrimonio de clubes en pesos y dolares (tipo de cambio $955)
-- ------------------------------------------------------------
SELECT
    id_club           AS "CLUB",
    nombre_club       AS "NOMBRE CLUB",
    patrimonio        AS "PATRIMONIO EN PESOS",
    patrimonio / 955  AS "PATRIMONIO EN DOLARES"
FROM CLUB_FUTBOL
WHERE nombre_club LIKE '%a%'
  AND patrimonio > 200000000
  AND tipo_club = 'Profesional'
ORDER BY id_club DESC;