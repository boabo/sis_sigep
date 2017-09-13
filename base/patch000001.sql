
/***********************************I-SCP-FEA-SIGEP-0-11/09/2017****************************************/
CREATE TABLE sigep.tacreedor (
  id_acreedor SERIAL,
  acreedor INTEGER NOT NULL,
  desc_acreedor VARCHAR(250) NOT NULL,
  tipo_acreedor VARCHAR(25) NOT NULL,
  de_ley VARCHAR(5) NOT NULL,
  id_tipo_obligacion_columna INTEGER,
  id_afp INTEGER,
  CONSTRAINT tacreedor_pkey PRIMARY KEY(id_acreedor)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tacreedor
  ALTER COLUMN id_acreedor SET STATISTICS 0;

ALTER TABLE sigep.tacreedor
  ALTER COLUMN acreedor SET STATISTICS 0;

ALTER TABLE sigep.tacreedor
  ALTER COLUMN desc_acreedor SET STATISTICS 0;

ALTER TABLE sigep.tacreedor
  ALTER COLUMN tipo_acreedor SET STATISTICS 0;

ALTER TABLE sigep.tacreedor
  ALTER COLUMN de_ley SET STATISTICS 0;

ALTER TABLE sigep.tacreedor
  ALTER COLUMN id_tipo_obligacion_columna SET STATISTICS 0;

ALTER TABLE sigep.tacreedor
  ALTER COLUMN id_afp SET STATISTICS 0;



CREATE TABLE sigep.tbanco (
  id_banco_boa SERIAL,
  banco INTEGER NOT NULL,
  desc_banco VARCHAR(250) NOT NULL,
  id_institucion INTEGER,
  spt VARCHAR(5),
  CONSTRAINT tbanco_pkey PRIMARY KEY(id_banco_boa)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tbanco
  ALTER COLUMN id_banco_boa SET STATISTICS 0;

ALTER TABLE sigep.tbanco
  ALTER COLUMN banco SET STATISTICS 0;

ALTER TABLE sigep.tbanco
  ALTER COLUMN desc_banco SET STATISTICS 0;

ALTER TABLE sigep.tbanco
  ALTER COLUMN id_institucion SET STATISTICS 0;


CREATE TABLE sigep.tcatalogo_proyecto (
  id_catalogo_proyecto SERIAL,
  id_catpry INTEGER NOT NULL,
  id_entidad INTEGER NOT NULL,
  sisin VARCHAR(50) NOT NULL,
  desc_catpry VARCHAR(1000) NOT NULL,
  id_catprg INTEGER NOT NULL,
  id_cp_proyecto INTEGER,
  id_gestion INTEGER,
  CONSTRAINT tcatalogo_proyecto_pkey PRIMARY KEY(id_catalogo_proyecto),
  CONSTRAINT tcatalogo_proyecto_fk FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tcatalogo_proyecto_fk1 FOREIGN KEY (id_cp_proyecto)
    REFERENCES pre.tcp_proyecto(id_cp_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tcatalogo_proyecto
  ALTER COLUMN id_catalogo_proyecto SET STATISTICS 0;

ALTER TABLE sigep.tcatalogo_proyecto
  ALTER COLUMN id_catpry SET STATISTICS 0;



CREATE TABLE sigep.tclase_gasto_cip (
  id_clase_gasto_cip SERIAL,
  clase_gasto INTEGER NOT NULL,
  desc_clase_gasto VARCHAR(250) NOT NULL,
  id_clase_gasto INTEGER,
  CONSTRAINT tclase_gasto_cip_pkey PRIMARY KEY(id_clase_gasto_cip)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tclase_gasto_cip
  ALTER COLUMN id_clase_gasto_cip SET STATISTICS 0;

ALTER TABLE sigep.tclase_gasto_cip
  ALTER COLUMN clase_gasto SET STATISTICS 0;

ALTER TABLE sigep.tclase_gasto_cip
  ALTER COLUMN desc_clase_gasto SET STATISTICS 0;

ALTER TABLE sigep.tclase_gasto_cip
  ALTER COLUMN id_clase_gasto SET STATISTICS 0;


CREATE TABLE sigep.tclase_gasto_sip (
  id_clase_gasto_sip SERIAL,
  clase_gasto INTEGER NOT NULL,
  desc_clase_gasto VARCHAR(100) NOT NULL,
  id_clase_gasto INTEGER,
  CONSTRAINT tclase_gasto_sip_pkey PRIMARY KEY(id_clase_gasto_sip)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tclase_gasto_sip
  ALTER COLUMN id_clase_gasto_sip SET STATISTICS 0;

ALTER TABLE sigep.tclase_gasto_sip
  ALTER COLUMN clase_gasto SET STATISTICS 0;

ALTER TABLE sigep.tclase_gasto_sip
  ALTER COLUMN desc_clase_gasto SET STATISTICS 0;

ALTER TABLE sigep.tclase_gasto_sip
  ALTER COLUMN id_clase_gasto SET STATISTICS 0;



CREATE TABLE sigep.tcuenta_bancaria (
  id_cuenta_bancaria_boa SERIAL,
  banco INTEGER NOT NULL,
  cuenta VARCHAR(50) NOT NULL,
  desc_cuenta VARCHAR(250) NOT NULL,
  moneda INTEGER NOT NULL,
  tipo_cuenta CHAR(5) NOT NULL,
  estado_cuenta CHAR(5) NOT NULL,
  id_cuenta_bancaria INTEGER,
  CONSTRAINT tcuenta_bancaria_pkey PRIMARY KEY(id_cuenta_bancaria_boa),
  CONSTRAINT tcuenta_bancaria_fk FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tcuenta_bancaria
  ALTER COLUMN id_cuenta_bancaria_boa SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_bancaria
  ALTER COLUMN banco SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_bancaria
  ALTER COLUMN cuenta SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_bancaria
  ALTER COLUMN desc_cuenta SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_bancaria
  ALTER COLUMN moneda SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_bancaria
  ALTER COLUMN tipo_cuenta SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_bancaria
  ALTER COLUMN id_cuenta_bancaria SET STATISTICS 0;


CREATE TABLE sigep.tcuenta_contable (
  id_cuenta_contable SERIAL,
  modelo_contable INTEGER NOT NULL,
  cuenta_contable VARCHAR(50) NOT NULL,
  des_cuenta_contable VARCHAR(250) NOT NULL,
  imputable VARCHAR(5) NOT NULL,
  id_cuenta INTEGER,
  id_gestion INTEGER,
  CONSTRAINT tcuenta_contable_pkey PRIMARY KEY(id_cuenta_contable)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tcuenta_contable
  ALTER COLUMN id_cuenta_contable SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_contable
  ALTER COLUMN modelo_contable SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_contable
  ALTER COLUMN cuenta_contable SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_contable
  ALTER COLUMN des_cuenta_contable SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_contable
  ALTER COLUMN imputable SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_contable
  ALTER COLUMN id_cuenta SET STATISTICS 0;

ALTER TABLE sigep.tcuenta_contable
  ALTER COLUMN id_gestion SET STATISTICS 0;


CREATE TABLE sigep.tdireccion_administrativa (
  id_direccion_administrativa_boa INTEGER DEFAULT nextval('sigep.tdireccion_administrativa_id_direccion_administrativa_seq'::regclass) NOT NULL,
  id_da INTEGER NOT NULL,
  id_entidad INTEGER NOT NULL,
  da INTEGER NOT NULL,
  desc_da VARCHAR(150) NOT NULL,
  tipo_da INTEGER NOT NULL,
  id_direccion_administrativa INTEGER,
  id_gestion INTEGER,
  CONSTRAINT tdireccion_administrativa_pkey PRIMARY KEY(id_direccion_administrativa_boa),
  CONSTRAINT tdireccion_administrativa_fk FOREIGN KEY (id_direccion_administrativa)
    REFERENCES pre.tdireccion_administrativa(id_direccion_administrativa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tdireccion_administrativa_fk1 FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tdireccion_administrativa
  ALTER COLUMN id_direccion_administrativa_boa SET STATISTICS 0;

ALTER TABLE sigep.tdireccion_administrativa
  ALTER COLUMN id_da SET STATISTICS 0;

ALTER TABLE sigep.tdireccion_administrativa
  ALTER COLUMN id_entidad SET STATISTICS 0;

ALTER TABLE sigep.tdireccion_administrativa
  ALTER COLUMN da SET STATISTICS 0;

ALTER TABLE sigep.tdireccion_administrativa
  ALTER COLUMN desc_da SET STATISTICS 0;

ALTER TABLE sigep.tdireccion_administrativa
  ALTER COLUMN tipo_da SET STATISTICS 0;

ALTER TABLE sigep.tdireccion_administrativa
  ALTER COLUMN id_gestion SET STATISTICS 0;


CREATE TABLE sigep.tdocumento_respaldo (
  id_documento_respaldo SERIAL,
  documento_respaldo INTEGER NOT NULL,
  sigla VARCHAR(100) NOT NULL,
  desc_documento VARCHAR(250) NOT NULL,
  CONSTRAINT tdocumento_respaldo_pkey PRIMARY KEY(id_documento_respaldo)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tdocumento_respaldo
  ALTER COLUMN id_documento_respaldo SET STATISTICS 0;

ALTER TABLE sigep.tdocumento_respaldo
  ALTER COLUMN documento_respaldo SET STATISTICS 0;

ALTER TABLE sigep.tdocumento_respaldo
  ALTER COLUMN sigla SET STATISTICS 0;

ALTER TABLE sigep.tdocumento_respaldo
  ALTER COLUMN desc_documento SET STATISTICS 0;


CREATE TABLE sigep.tentidad (
  id_entidad_boa INTEGER DEFAULT nextval('sigep.tentidad_id_tentidad_seq'::regclass) NOT NULL,
  id_entidad INTEGER NOT NULL,
  entidad INTEGER NOT NULL,
  desc_entidad VARCHAR(250) NOT NULL,
  sigla_entidad VARCHAR(25) NOT NULL,
  tuicion_entidad INTEGER,
  id_institucion INTEGER,
  CONSTRAINT tentidad_pkey PRIMARY KEY(id_entidad_boa),
  CONSTRAINT tentidad_fk FOREIGN KEY (id_institucion)
    REFERENCES param.tinstitucion(id_institucion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tentidad
  ALTER COLUMN id_entidad_boa SET STATISTICS 0;

ALTER TABLE sigep.tentidad
  ALTER COLUMN id_entidad SET STATISTICS 0;

ALTER TABLE sigep.tentidad
  ALTER COLUMN entidad SET STATISTICS 0;

ALTER TABLE sigep.tentidad
  ALTER COLUMN desc_entidad SET STATISTICS 0;

ALTER TABLE sigep.tentidad
  ALTER COLUMN sigla_entidad SET STATISTICS 0;

ALTER TABLE sigep.tentidad
  ALTER COLUMN tuicion_entidad SET STATISTICS 0;


CREATE TABLE sigep.tfuente_financiamiento (
  id_fuente_financiamiento SERIAL,
  id_fuente INTEGER NOT NULL,
  fuente INTEGER NOT NULL,
  desc_fuente VARCHAR(250) NOT NULL,
  sigla_fuente VARCHAR(25) NOT NULL,
  id_cp_fuente_fin INTEGER,
  id_gestion INTEGER,
  CONSTRAINT tfuente_financiamiento_pkey PRIMARY KEY(id_fuente_financiamiento),
  CONSTRAINT tfuente_financiamiento_fk FOREIGN KEY (id_cp_fuente_fin)
    REFERENCES pre.tcp_fuente_fin(id_cp_fuente_fin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tfuente_financiamiento_fk1 FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tfuente_financiamiento
  ALTER COLUMN id_fuente_financiamiento SET STATISTICS 0;

ALTER TABLE sigep.tfuente_financiamiento
  ALTER COLUMN id_fuente SET STATISTICS 0;

ALTER TABLE sigep.tfuente_financiamiento
  ALTER COLUMN fuente SET STATISTICS 0;

ALTER TABLE sigep.tfuente_financiamiento
  ALTER COLUMN desc_fuente SET STATISTICS 0;

ALTER TABLE sigep.tfuente_financiamiento
  ALTER COLUMN sigla_fuente SET STATISTICS 0;


CREATE TABLE sigep.tlibreta (
  id_libreta_boa SERIAL,
  banco INTEGER NOT NULL,
  cuenta VARCHAR(25) NOT NULL,
  id_libreta INTEGER NOT NULL,
  libreta VARCHAR(25) NOT NULL,
  desc_libreta VARCHAR(250) NOT NULL,
  moneda INTEGER NOT NULL,
  estado_libre CHAR(5) NOT NULL,
  id_cuenta_bancaria INTEGER,
  CONSTRAINT tlibreta_pkey PRIMARY KEY(id_libreta_boa)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tlibreta
  ALTER COLUMN id_libreta_boa SET STATISTICS 0;

ALTER TABLE sigep.tlibreta
  ALTER COLUMN banco SET STATISTICS 0;

ALTER TABLE sigep.tlibreta
  ALTER COLUMN cuenta SET STATISTICS 0;

ALTER TABLE sigep.tlibreta
  ALTER COLUMN id_libreta SET STATISTICS 0;

ALTER TABLE sigep.tlibreta
  ALTER COLUMN libreta SET STATISTICS 0;

ALTER TABLE sigep.tlibreta
  ALTER COLUMN desc_libreta SET STATISTICS 0;

ALTER TABLE sigep.tlibreta
  ALTER COLUMN moneda SET STATISTICS 0;

ALTER TABLE sigep.tlibreta
  ALTER COLUMN estado_libre SET STATISTICS 0;


CREATE TABLE sigep.tmatriz_control (
  id_matriz_control SERIAL,
  banco VARCHAR(25) NOT NULL,
  cuenta VARCHAR(25) NOT NULL,
  id_libreta INTEGER NOT NULL,
  libreta VARCHAR(25) NOT NULL,
  CONSTRAINT tmatriz_control_pkey PRIMARY KEY(id_matriz_control)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tmatriz_control
  ALTER COLUMN id_matriz_control SET STATISTICS 0;

ALTER TABLE sigep.tmatriz_control
  ALTER COLUMN banco SET STATISTICS 0;

ALTER TABLE sigep.tmatriz_control
  ALTER COLUMN cuenta SET STATISTICS 0;

ALTER TABLE sigep.tmatriz_control
  ALTER COLUMN id_libreta SET STATISTICS 0;

ALTER TABLE sigep.tmatriz_control
  ALTER COLUMN libreta SET STATISTICS 0;


CREATE TABLE sigep.tmoneda (
  id_moneda_boa SERIAL,
  moneda INTEGER NOT NULL,
  desc_moneda VARCHAR(100) NOT NULL,
  id_moneda INTEGER,
  pais VARCHAR(10),
  CONSTRAINT tmoneda_pkey PRIMARY KEY(id_moneda_boa),
  CONSTRAINT tmoneda_fk FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tmoneda
  ALTER COLUMN id_moneda_boa SET STATISTICS 0;

ALTER TABLE sigep.tmoneda
  ALTER COLUMN moneda SET STATISTICS 0;

ALTER TABLE sigep.tmoneda
  ALTER COLUMN desc_moneda SET STATISTICS 0;


CREATE TABLE sigep.tobjeto_gasto (
  id_objeto_gasto SERIAL,
  id_objeto INTEGER NOT NULL,
  objeto VARCHAR(20) NOT NULL,
  desc_objeto VARCHAR(1000) NOT NULL,
  nivel VARCHAR(20) NOT NULL,
  id_partida INTEGER,
  id_gestion INTEGER,
  CONSTRAINT tobjeto_gasto_pkey PRIMARY KEY(id_objeto_gasto),
  CONSTRAINT tobjeto_gasto_fk FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tobjeto_gasto_fk1 FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tobjeto_gasto
  ALTER COLUMN id_objeto_gasto SET STATISTICS 0;

ALTER TABLE sigep.tobjeto_gasto
  ALTER COLUMN id_objeto SET STATISTICS 0;

ALTER TABLE sigep.tobjeto_gasto
  ALTER COLUMN objeto SET STATISTICS 0;

ALTER TABLE sigep.tobjeto_gasto
  ALTER COLUMN desc_objeto SET STATISTICS 0;

ALTER TABLE sigep.tobjeto_gasto
  ALTER COLUMN nivel SET STATISTICS 0;

ALTER TABLE sigep.tobjeto_gasto
  ALTER COLUMN id_partida SET STATISTICS 0;


CREATE TABLE sigep.torganismo_financiador (
  id_organismo_financiador SERIAL,
  id_organismo INTEGER NOT NULL,
  organismo INTEGER NOT NULL,
  desc_organismo VARCHAR(300) NOT NULL,
  sigla_organismo VARCHAR(25) NOT NULL,
  id_cp_organismo_fin INTEGER,
  id_gestion INTEGER,
  CONSTRAINT torganismo_financiador_pkey PRIMARY KEY(id_organismo_financiador),
  CONSTRAINT torganismo_financiador_fk FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT torganismo_financiador_fk1 FOREIGN KEY (id_cp_organismo_fin)
    REFERENCES pre.tcp_organismo_fin(id_cp_organismo_fin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.torganismo_financiador
  ALTER COLUMN id_organismo_financiador SET STATISTICS 0;

ALTER TABLE sigep.torganismo_financiador
  ALTER COLUMN id_organismo SET STATISTICS 0;

ALTER TABLE sigep.torganismo_financiador
  ALTER COLUMN organismo SET STATISTICS 0;

ALTER TABLE sigep.torganismo_financiador
  ALTER COLUMN desc_organismo SET STATISTICS 0;

ALTER TABLE sigep.torganismo_financiador
  ALTER COLUMN sigla_organismo SET STATISTICS 0;


CREATE TABLE sigep.totfin (
  id_otfin SERIAL,
  otfin VARCHAR(50) NOT NULL,
  id_entidad INTEGER NOT NULL,
  desc_otfin VARCHAR(250) NOT NULL,
  CONSTRAINT totfin_pkey PRIMARY KEY(id_otfin)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.totfin
  ALTER COLUMN id_otfin SET STATISTICS 0;

ALTER TABLE sigep.totfin
  ALTER COLUMN otfin SET STATISTICS 0;

ALTER TABLE sigep.totfin
  ALTER COLUMN id_entidad SET STATISTICS 0;

ALTER TABLE sigep.totfin
  ALTER COLUMN desc_otfin SET STATISTICS 0;


CREATE TABLE sigep.tpresupuesto_gasto (
  id_presupuesto_gasto SERIAL,
  gestion INTEGER NOT NULL,
  id_ptogto INTEGER NOT NULL,
  id_entidad INTEGER NOT NULL,
  id_da INTEGER NOT NULL,
  id_ue INTEGER NOT NULL,
  id_catprg INTEGER NOT NULL,
  id_catpry INTEGER,
  id_fuente INTEGER NOT NULL,
  id_organismo INTEGER NOT NULL,
  id_objeto INTEGER NOT NULL,
  id_ent_transferencia INTEGER NOT NULL,
  ppto_inicial NUMERIC(18,2) NOT NULL,
  ppto_vigente NUMERIC(18,2) NOT NULL,
  credito_disponible NUMERIC(18,2) NOT NULL,
  id_gestion INTEGER,
  CONSTRAINT tpresupuesto_gasto_pkey PRIMARY KEY(id_presupuesto_gasto),
  CONSTRAINT tpresupuesto_gasto_fk FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tpresupuesto_gasto
  ALTER COLUMN id_presupuesto_gasto SET STATISTICS 0;

ALTER TABLE sigep.tpresupuesto_gasto
  ALTER COLUMN gestion SET STATISTICS 0;

ALTER TABLE sigep.tpresupuesto_gasto
  ALTER COLUMN id_ptogto SET STATISTICS 0;

ALTER TABLE sigep.tpresupuesto_gasto
  ALTER COLUMN id_entidad SET STATISTICS 0;



CREATE TABLE sigep.tprograma (
  id_programa_boa INTEGER DEFAULT nextval('sigep.tprograma_id_programa_seq'::regclass) NOT NULL,
  id_catprg INTEGER NOT NULL,
  id_entidad INTEGER NOT NULL,
  programa INTEGER NOT NULL,
  desc_catprg VARCHAR(200) NOT NULL,
  nivel VARCHAR(50) NOT NULL,
  id_cp_programa INTEGER,
  id_gestion INTEGER,
  CONSTRAINT tprograma_pkey PRIMARY KEY(id_programa_boa),
  CONSTRAINT tprograma_fk FOREIGN KEY (id_cp_programa)
    REFERENCES pre.tcp_programa(id_cp_programa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tprograma_fk1 FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tprograma
  ALTER COLUMN id_programa_boa SET STATISTICS 0;

ALTER TABLE sigep.tprograma
  ALTER COLUMN id_catprg SET STATISTICS 0;

ALTER TABLE sigep.tprograma
  ALTER COLUMN id_entidad SET STATISTICS 0;

ALTER TABLE sigep.tprograma
  ALTER COLUMN programa SET STATISTICS 0;

ALTER TABLE sigep.tprograma
  ALTER COLUMN desc_catprg SET STATISTICS 0;

ALTER TABLE sigep.tprograma
  ALTER COLUMN nivel SET STATISTICS 0;

ALTER TABLE sigep.tprograma
  ALTER COLUMN id_cp_programa SET STATISTICS 0;

ALTER TABLE sigep.tprograma
  ALTER COLUMN id_gestion SET STATISTICS 0;


CREATE TABLE sigep.tproyecto_actividad (
  id_proyecto_actividad SERIAL,
  id_catprg INTEGER NOT NULL,
  id_entidad INTEGER NOT NULL,
  programa INTEGER NOT NULL,
  proyecto INTEGER NOT NULL,
  actividad INTEGER NOT NULL,
  desc_catprg VARCHAR(1000) NOT NULL,
  nivel VARCHAR(20) NOT NULL,
  id_programa INTEGER NOT NULL,
  id_categoria_programatica INTEGER,
  CONSTRAINT tproyecto_actividad_pkey PRIMARY KEY(id_proyecto_actividad),
  CONSTRAINT tproyecto_actividad_fk FOREIGN KEY (id_categoria_programatica)
    REFERENCES pre.tcategoria_programatica(id_categoria_programatica)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tproyecto_actividad
  ALTER COLUMN id_proyecto_actividad SET STATISTICS 0;

ALTER TABLE sigep.tproyecto_actividad
  ALTER COLUMN id_catprg SET STATISTICS 0;

ALTER TABLE sigep.tproyecto_actividad
  ALTER COLUMN id_entidad SET STATISTICS 0;


CREATE TABLE sigep.tsigade (
  id_sigade SERIAL,
  sigade VARCHAR(50),
  desc_sigade VARCHAR(250),
  tipo_deuda VARCHAR(5),
  CONSTRAINT tsigade_pkey PRIMARY KEY(id_sigade)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tsigade
  ALTER COLUMN id_sigade SET STATISTICS 0;

ALTER TABLE sigep.tsigade
  ALTER COLUMN sigade SET STATISTICS 0;

ALTER TABLE sigep.tsigade
  ALTER COLUMN tipo_deuda SET STATISTICS 0;


CREATE TABLE sigep.tunidad_ejecutora (
  id_unidad_ejecutora_boa INTEGER DEFAULT nextval('sigep.tunidad_ejecutora_id_unidad_ejecutora_seq'::regclass) NOT NULL,
  id_ue INTEGER NOT NULL,
  id_da INTEGER NOT NULL,
  ue INTEGER NOT NULL,
  desc_ue VARCHAR(150) NOT NULL,
  id_unidad_ejecutora INTEGER,
  id_gestion INTEGER,
  CONSTRAINT tunidad_ejecutora_pkey PRIMARY KEY(id_unidad_ejecutora_boa),
  CONSTRAINT tunidad_ejecutora_fk FOREIGN KEY (id_unidad_ejecutora)
    REFERENCES pre.tunidad_ejecutora(id_unidad_ejecutora)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tunidad_ejecutora_fk1 FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE sigep.tunidad_ejecutora
  ALTER COLUMN id_unidad_ejecutora_boa SET STATISTICS 0;

ALTER TABLE sigep.tunidad_ejecutora
  ALTER COLUMN id_ue SET STATISTICS 0;

ALTER TABLE sigep.tunidad_ejecutora
  ALTER COLUMN id_da SET STATISTICS 0;

ALTER TABLE sigep.tunidad_ejecutora
  ALTER COLUMN ue SET STATISTICS 0;

ALTER TABLE sigep.tunidad_ejecutora
  ALTER COLUMN desc_ue SET STATISTICS 0;

ALTER TABLE sigep.tunidad_ejecutora
  ALTER COLUMN id_unidad_ejecutora SET STATISTICS 0;

ALTER TABLE sigep.tunidad_ejecutora
  ALTER COLUMN id_gestion SET STATISTICS 0;
/***********************************F-SCP-FEA-SIGEP-0-11/09/2017****************************************/