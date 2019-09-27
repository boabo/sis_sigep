CREATE OR REPLACE FUNCTION sigep.ft_sigep_adq_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_sigep_adq_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tsigep_adq_det'
 AUTOR: 		 (rzabala)
 FECHA:	        25-03-2019 15:50:47
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				25-03-2019 15:50:47								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tsigep_adq_det'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_sigep_adq_det		integer;
    v_record_sol			record;
    v_registros				record;
    v_datos_sigep			record;
    v_id_sigep_adq_s		numeric;
    v_id_sigep_cont_s		integer;
    v_id_sigep_regu_s		INTEGER[];
    map_moneda				numeric;
    v_record				record;
    v_fecha					date;
    v_momento	            varchar;
    v_array_str	            text;
    v_preventivo     		record;
    cuenta_apro				varchar;
    v_nro_tramite			varchar;
    v_total					numeric;
    v_i					integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_sigep_adq_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_SAD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rzabala
 	#FECHA:		25-03-2019 15:50:47
	***********************************/

	if(p_transaccion='SIGEP_SAD_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tsigep_adq_det(
            estado_reg,
            id_sigep_adq,
			gestion,
			clase_gasto_cip,
			moneda,
			total_autorizado_mo,
			id_ptogto,
			monto_partida,
			tipo_doc_rdo,
			nro_doc_rdo,
			sec_doc_rdo,
			fecha_elaboracion,
			justificacion,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
            v_parametros.id_sigep_adq,
			v_parametros.gestion,
			v_parametros.clase_gasto_cip,
			v_parametros.moneda,
			v_parametros.total_autorizado_mo,
			v_parametros.id_ptogto,
			v_parametros.monto_partida,
			v_parametros.tipo_doc_rdo,
			v_parametros.nro_doc_rdo,
			v_parametros.sec_doc_rdo,
			v_parametros.fecha_elaboracion,
			v_parametros.justificacion,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_sigep_adq_det into v_id_sigep_adq_det;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep Adquisiciones Detalle almacenado(a) con exito (id_sigep_adq_det'||v_id_sigep_adq_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq_det',v_id_sigep_adq_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

         /*********************************
 	#TRANSACCION:  'SIGEP_SAD_CHAR'
 	#DESCRIPCION:	carga datos del siguiente estado de la solcitud para envio a Sigep
 	#AUTOR:		rzabala
 	#FECHA:		27-03-2019 17:32:51
	***********************************/

	elseif(p_transaccion='SIGEP_SAD_CHAR')then
        begin

       --raise exception 'LLEGO AL SERVICIO SIGEP: %', v_parametros.id_proceso_wf_act;

        SELECT ts.estado, ts.id_estado_wf, ts.justificacion, ts.id_gestion
    	INTO v_record_sol
        FROM adq.tsolicitud ts
        WHERE ts.id_proceso_wf = v_parametros.id_proceso_wf_act::int8;

        --raise exception 'checkpoint SERVICIO SIGEP: %', v_record_sol;

 		FOR v_record IN (WITH RECURSIVE firmas(id_estado_fw, id_estado_anterior,fecha_reg, codigo, id_funcionario) AS (
                                SELECT tew.id_estado_wf, tew.id_estado_anterior , tew.fecha_reg, te.codigo, tew.id_funcionario
                                FROM wf.testado_wf tew
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = tew.id_tipo_estado
                                WHERE tew.id_estado_wf = v_record_sol.id_estado_wf

                                UNION ALL

                                SELECT ter.id_estado_wf, ter.id_estado_anterior, ter.fecha_reg, te.codigo, ter.id_funcionario
                                FROM wf.testado_wf ter
                                INNER JOIN firmas f ON f.id_estado_anterior = ter.id_estado_wf
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = ter.id_tipo_estado
                                WHERE f.id_estado_anterior IS NOT NULL
                            )SELECT distinct on (codigo) codigo, fecha_reg , id_estado_fw, id_estado_anterior, id_funcionario FROM firmas ORDER BY codigo, fecha_reg DESC) LOOP
                  IF(v_record.codigo = 'vbpoa' OR v_record.codigo = 'suppresu' OR v_record.codigo = 'vbpresupuestos' OR v_record.codigo = 'vbrpc')THEN
                  		v_fecha = v_record.fecha_reg;
                        IF(v_record.codigo = 'suppresu')THEN
                        	select us.cuenta
                            into cuenta_apro
								from segu.tusuario us
								inner join orga.tfuncionario fun on fun.id_persona = us.id_persona
								where fun.id_funcionario = v_record.id_funcionario;
                        END IF;
                   END IF;

              END LOOP;

              --raise exception 'FECHA SOLICITUD SERVICIO SIGEP: %', v_fecha;

            SELECT tcg.codigo AS codigo_cg,
			       tcg.nombre AS nombre_cg,
                   --sum(tsd.precio_total) as total_autorizado,
			       ts.num_tramite,
                   substring(ts.num_tramite from 8 for 5) as nro_respaldo,
                   tmo.id_moneda
            into v_datos_sigep
			FROM adq.tsolicitud ts
				INNER JOIN adq.tsolicitud_det tsd ON tsd.id_solicitud = ts.id_solicitud
				INNER JOIN pre.tpartida tpar ON tpar.id_partida = tsd.id_partida
				INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
				INNER JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                INNER JOIN sigep.tclase_gasto_cip stcg on stcg.id_clase_gasto = tcg.id_clase_gasto
                INNER JOIN param.tmoneda tmo ON tmo.id_moneda = ts.id_moneda

				WHERE tsd.estado_reg = 'activo' AND ts.id_proceso_wf = v_parametros.id_proceso_wf_act::int8
 				group by 	tcg.codigo, tcg.nombre,	ts.num_tramite, tmo.id_moneda;

            IF (v_datos_sigep = '')THEN
            	raise exception 'ERROR! REGISTRAR DATOS ERP EN INTEGRACION SIGEP/CLASIFICADORES: %', v_datos_sigep;
            END IF;


            insert into sigep.tsigep_adq(
			estado_reg,
			num_tramite,
			estado,
			momento,
			ultimo_mensaje,
			clase_gasto,
            --nro_preventivo,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_datos_sigep.num_tramite,
			'pre-registro',
			v_parametros.momento,
			'',
			v_datos_sigep.nombre_cg,
            --'',
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_sigep_adq into v_id_sigep_adq_s;

            select mo.moneda
            into map_moneda
			from sigep.tmoneda mo
			where mo.id_moneda=v_datos_sigep.id_moneda;

            SELECT
       			sum(tsd.precio_total) as total_autorizado
                into
                v_total
			FROM adq.tsolicitud ts
    		INNER JOIN adq.tsolicitud_det tsd ON tsd.id_solicitud = ts.id_solicitud
    		WHERE tsd.estado_reg = 'activo' and ts.id_proceso_wf = v_parametros.id_proceso_wf_act::int8;

for v_registros in (	SELECT 	vcp.codigo_programa ,
                                vcp.codigo_proyecto,
                                vcp.codigo_actividad,
                                vcp.codigo_fuente_fin,
                                vcp.codigo_origen_fin,
                                tpar.codigo AS codigo_partida,
                                tcg.codigo AS codigo_cg,
                                tcg.nombre AS nombre_cg,
                                sum(tsd.precio_total) as precio_total,
                                tmo.codigo AS codigo_moneda,
                                tmo.id_moneda,
                                ts.num_tramite,
                                pregas.id_ptogto,
                                ts.fecha_soli,
                                COALESCE(tg.gestion, (extract(year from now()::date))::integer) AS gestion,
                                pregas.id_fuente,
                                pregas.id_organismo
                        FROM adq.tsolicitud ts
                        INNER JOIN adq.tsolicitud_det tsd ON tsd.id_solicitud = ts.id_solicitud

                        INNER JOIN pre.tpartida tpar ON tpar.id_partida = tsd.id_partida

                        inner join param.tgestion tg on tg.id_gestion = ts.id_gestion

                        inner JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tsd.id_centro_costo
                        inner JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog

                        inner JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                        inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto

                        INNER JOIN param.tmoneda tmo ON tmo.id_moneda = ts.id_moneda

                        left JOIN pre.tpresupuesto_partida_entidad tppe ON tppe.id_partida = tpar.id_partida AND tppe.id_presupuesto = tp.id_presupuesto
                        LEFT JOIN pre.tentidad_transferencia tet ON tet.id_entidad_transferencia = tppe.id_entidad_transferencia

                        inner JOIN sigep.tproyecto_actividad proyact on vcp.id_categoria_programatica = proyact.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg

                        inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = tg.id_gestion

                        inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = tg.id_gestion and pregas.id_objeto = objgas.id_objeto
                        WHERE
                                tsd.estado_reg = 'activo'
                                AND ts.id_proceso_wf = v_parametros.id_proceso_wf_act::int8

                        group by pregas.id_ptogto,vcp.codigo_programa,vcp.codigo_proyecto, vcp.codigo_actividad, vcp.codigo_fuente_fin, vcp.codigo_origen_fin,
                                tpar.codigo, tcg.codigo, tcg.nombre, tmo.codigo, tmo.id_moneda, ts.num_tramite, ts.fecha_soli,
                                tg.gestion, pregas.id_fuente, pregas.id_organismo )loop
        				--raise exception 'DATOS SERVICIO SIGEP: %', v_registros;
                        --raise exception 'cuenta: %', cuenta_apro;
                         insert into sigep.tsigep_adq_det(
            									estado_reg,
            									id_sigep_adq,
												gestion,
												clase_gasto_cip,
												moneda,
												total_autorizado_mo,
												id_ptogto,
												monto_partida,
												tipo_doc_rdo,
												nro_doc_rdo,
												sec_doc_rdo,
												fecha_elaboracion,
												justificacion,
            									id_fuente,
            									id_organismo,
												id_usuario_reg,
                                                usuario_apro,
												fecha_reg,
												id_usuario_ai,
												usuario_ai,
												id_usuario_mod,
												fecha_mod
          										) values(
												'activo',
            									v_id_sigep_adq_s,
												v_registros.gestion,
												v_registros.codigo_cg::int8,
												map_moneda,
												v_total,	---monto_total_autorizado
												v_registros.id_ptogto,
												v_registros.precio_total,	---monto_partida
												'4',	--tipo_doc_rdo
												v_datos_sigep.nro_respaldo::int8,		--nro_doc_rdo,
												'1',	--sec_doc_rdo,
												v_fecha, --fecha_elaboracion
												upper(concat('De acuerdo a instrucciones impartidas en Número de Trámite ', v_registros.num_tramite,', se reserva fondos para la contratacion de ', v_record_sol.justificacion, ', de acuerdo a documentación adjunta.')),
            									v_registros.id_fuente,
            									v_registros.id_organismo,
												p_id_usuario,
                                                cuenta_apro,
												now(),
												v_parametros._id_usuario_ai,
												v_parametros._nombre_usuario_ai,
												null,
												null
            									);
	        		end loop;


          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_adq'||v_id_sigep_adq_s||')');
          v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq',v_id_sigep_adq_s::varchar);


          -- Devuelve la respuesta
          return v_resp;

     end;

 /*     /*********************************
 	#TRANSACCION:  'SIGEP_SCONT_CHAR'
 	#DESCRIPCION:	carga datos del siguiente estado de Cbte Contabilidad para envio a Sigep
 	#AUTOR:		rzabala
 	#FECHA:		16-05-2019 15:32:51
	***********************************/

	elseif(p_transaccion='SIGEP_SCONT_CHAR')then
        begin
        --raise exception 'LLEGO AL SERVICIO SIGEP CONT: %', v_parametros.num_tramite;

         SELECT
 				obpag.num_tramite,
            	sig.nro_preventivo,
            	sig.clase_gasto,
	            ges.gestion,
    	        sigd.clase_gasto_cip,
        	    mo.moneda,
            	pla.liquido_pagable,
	            sigd.id_ptogto,
    	        pla.monto_ejecutar_total_mo,
        	    sigd.tipo_doc_rdo,
            	sigd.nro_doc_rdo,
	            sigd.sec_doc_rdo,
    	        obpag.fecha,
        	    pla.obs_monto_no_pagado,
            	sigd.id_fuente,
	            sigd.id_organismo,
    	        prov.id_beneficiario,
        	    ban.banco as banco_benef,
            	proc.nro_cuenta as cuenta_benef,
	            pla.monto,
    	        lib.banco,
        	    lib.cuenta,
            	lib.libreta
           		into v_registros
	    from tes.tobligacion_pago obpag
    	inner join tes.tplan_pago pla on pla.id_obligacion_pago = obpag.id_obligacion_pago
	    inner join param.tproveedor_cta_bancaria proc on proc.id_proveedor_cta_bancaria = pla.id_proveedor_cta_bancaria
    	inner join sigep.tlibreta lib on lib.id_cuenta_bancaria = pla.id_cuenta_bancaria
	    inner join sigep.tbanco ban on ban.id_institucion = proc.id_banco_beneficiario
    	inner join param.tproveedor prov on prov.id_proveedor = obpag.id_proveedor
	    inner join sigep.tsigep_adq sig on sig.num_tramite = obpag.num_tramite
    	inner join sigep.tsigep_adq_det sigd on sigd.id_sigep_adq = sig.id_sigep_adq
	    inner join param.tgestion ges on ges.id_gestion = obpag.id_gestion
    	inner join tes.tcuenta_bancaria banc on banc.id_cuenta_bancaria = pla.id_cuenta_bancaria
	    inner join sigep.tmoneda mo on mo.id_moneda = obpag.id_moneda
    	where
     	       sig.nro_preventivo is not null and
        	    pla.id_int_comprobante = v_parametros.id_int_comprobante
	    order by sig.nro_preventivo desc limit 1;

        if (v_registros.nro_preventivo is null)then
        	raise exception 'El Numero de Tramite no tiene etapa PREVENTIVO %',v_registros.num_tramite;
        end if;

        insert into sigep.tsigep_adq(
			estado_reg,
			num_tramite,
			estado,
			momento,
			ultimo_mensaje,
			clase_gasto,
            nro_preventivo,
            nro_comprometido,
            nro_devengado,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_registros.num_tramite,
			'pre-registro',
			v_parametros.momento,
			'',
			v_registros.clase_gasto,
            v_registros.nro_preventivo,
            '0',
            '0',
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_sigep_adq into v_id_sigep_cont_s;


       /* for v_registros in (select
        							sctdet.clase_gasto_cip,
                					sctdet.fecha_elaboracion,
					                sctdet.moneda,
					                sctdet.id_ptogto,
					                sctdet.gestion,
					                sctdet.monto_partida,
					                sctdet.total_autorizado_mo,
					                sctdet.nro_doc_rdo,
					                sctdet.sec_doc_rdo,
					                sctdet.tipo_doc_rdo,
					                sctdet.justificacion,
					                sctdet.id_fuente,
					                sctdet.id_organismo
					        into v_preventivo
					        from sigep.tsigep_adq scont
					        inner join sigep.tsigep_adq_det sctdet on sctdet.id_sigep_adq = scont.id_sigep_adq
					        where scont.num_tramite = v_nro_tramite)loop*/

        insert into sigep.tsigep_adq_det(
            estado_reg,
            id_sigep_adq,
			gestion,
			clase_gasto_cip,
			moneda,
			total_autorizado_mo,
			id_ptogto,
			monto_partida,
			tipo_doc_rdo,
			nro_doc_rdo,
			sec_doc_rdo,
			fecha_elaboracion,
			justificacion,
            beneficiario,
            banco_benef,
            cuenta_benef,
            id_fuente,
            id_organismo,
            banco_origen,
            cta_origen,
            libreta_origen,
            monto_benef,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
            v_id_sigep_cont_s,
			v_registros.gestion,
			v_registros.clase_gasto_cip::int8,
			v_registros.moneda,
			v_registros.liquido_pagable,
			v_registros.id_ptogto,
			v_registros.monto_ejecutar_total_mo,
			v_registros.tipo_doc_rdo,	--v_parametros.tipo_doc_rdo
			v_registros.nro_doc_rdo,	--v_parametros.nro_doc_rdo,
			v_registros.sec_doc_rdo,	--v_parametros.sec_doc_rdo,
			v_registros.fecha, --fecha_elaboracion
			upper(concat('Para registrar el ', v_registros.obs_monto_no_pagado,', de acuerdo a documentación adjunta.')),
            v_registros.id_beneficiario,
            v_registros.banco_benef,
            v_registros.cuenta_benef,
            v_registros.id_fuente,
            v_registros.id_organismo,
            v_registros.banco,
            v_registros.cuenta,
            v_registros.libreta,
            v_registros.monto,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
            );
            ---------actualizacion de C31 PREVENTIVO---------
            update conta.tint_comprobante
        	set c31 = v_registros.nro_preventivo,
            	fecha_c31 = v_registros.fecha
        	where id_int_comprobante = v_parametros.id_int_comprobante;

            --END LOOP;



          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
          v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_cont',v_id_sigep_cont_s::varchar);


          -- Devuelve la respuesta
          return v_resp;

     end;*/

/*********************************
 	#TRANSACCION:  'SIGEP_CIP_CHAR'
 	#DESCRIPCION:	carga datos del siguiente estado de Cbte Contabilidad para envio a Sigep CIP
 	#AUTOR:		rzabala
 	#FECHA:		16-09-2019 15:32:51
	***********************************/

	elseif(p_transaccion='SIGEP_CIP_CHAR')then
         begin
        --raise exception 'LLEGO AL SERVICIO SIGEP REGULARIZAR: %', v_parametros.momento;
        v_i = 1;
        --v_array_str = '';

       	FOR v_datos_sigep in ( SELECT  cob.nro_tramite,
        								tcg.nombre,
        								scg.clase_gasto,
                						to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                						sum(tra.importe_gasto) as monto
        						FROM conta.tint_comprobante cob
        							INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
        							INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
							      	INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
							        INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tra.id_centro_costo
							        INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
							      	inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
							        left JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                    left join sigep.tclase_gasto_sip tcgs on tcgs.id_clase_gasto = tcg.id_clase_gasto
							        inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
							        inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
							        inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto
							        INNER JOIN param.tgestion ges ON ges.id_gestion = vcp.id_gestion
						        WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf

							        group by cob.nro_tramite, scg.clase_gasto, tcg.nombre)loop



        insert into sigep.tsigep_adq(
			estado_reg,
			num_tramite,
			estado,
			momento,
			ultimo_mensaje,
			clase_gasto,
            nro_preventivo,
            nro_comprometido,
            nro_devengado,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_datos_sigep.nro_tramite,
			'pre-registro',
			v_parametros.momento,
			'',
			v_datos_sigep.nombre,
            null,
            null,
            null,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_sigep_adq into v_id_sigep_cont_s;
            v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
            --raise exception 'llega:%',  v_id_sigep_cont_s;
            v_array_str:=v_id_sigep_cont_s;
            --raise exception 'llega:%',  v_array_str;
            v_i = v_i+1;


       for v_registros in (	SELECT  cob.id_int_comprobante,
        							cob.nro_tramite,
        							cob.glosa1,
					                cue.nro_cuenta,
					                par.codigo,
					                cc.id_centro_costo,
					                to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
					                pregas.id_ptogto,
					                pregas.id_fuente,
					                pregas.id_organismo,
					                smo.moneda,
					                cp.id_categoria_programatica,
					                cp.codigo_categoria,
					                par.id_partida,
					                scg.clase_gasto,
					                scg.desc_clase_gasto,
					                sum(transa.importe_gasto) as monto,
                                    tpla.liquido_pagable,
                                    tpro.id_beneficiario,
                                    ban.banco as banco_benef,
					            	proc.nro_cuenta as cuenta_benef,
						            tpla.liquido_pagable as monto_benef,
                                    tpla.otros_descuentos as multas,
                                    tpla.monto_retgar_mo as retenciones,
					    	        lib.banco,
					        	    lib.cuenta,
					            	lib.libreta,
                                    ges.gestion
						       FROM conta.tint_comprobante cob
					        	inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
					            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
								left join pre.tpartida par on par.id_partida = transa.id_partida
								left join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
					            left join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
					            inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
					            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
					        	inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
					            inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
					            inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
					            inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto
                                LEFT JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = transa.id_cuenta_bancaria
        						left JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                left join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante
                                left join tes.tobligacion_pago tobpag on tobpag.id_obligacion_pago = tpla.id_obligacion_pago
                                left join param.tproveedor tpro on tpro.id_proveedor = tobpag.id_proveedor
                                left join param.tproveedor_cta_bancaria proc on proc.id_proveedor_cta_bancaria = tpla.id_proveedor_cta_bancaria
                                left join sigep.tbanco ban on ban.id_institucion = proc.id_banco_beneficiario
                                left join sigep.tlibreta lib on lib.id_cuenta_bancaria = tpla.id_cuenta_bancaria

					            left JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                LEFT JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
						       WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf

						       group by cob.id_int_comprobante, cob.glosa1,cue.nro_cuenta, par.codigo, cc.id_centro_costo, pregas.id_ptogto,
						                pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
						                par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, tpro.id_beneficiario,
                                        ban.banco, proc.nro_cuenta, tpla.monto, lib.banco, lib.cuenta, lib.libreta,ges.gestion,
                                        tpla.otros_descuentos, tpla.monto_retgar_mo, tpla.liquido_pagable )loop

       		if (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then
        		insert into sigep.tsigep_adq_det(
            		estado_reg,
		            id_sigep_adq,
					gestion,
					clase_gasto_cip,
					moneda,
					total_autorizado_mo,
					id_ptogto,
					monto_partida,
					tipo_doc_rdo,
					nro_doc_rdo,
					sec_doc_rdo,
					fecha_elaboracion,
					justificacion,
		            beneficiario,
		            banco_benef,
		            cuenta_benef,
		            id_fuente,
		            id_organismo,
		            banco_origen,
		            cta_origen,
		            libreta_origen,
		            monto_benef,
                    multa,
                    retencion,
                    liquido_pagable,
					id_usuario_reg,
					fecha_reg,
					id_usuario_ai,
					usuario_ai,
					id_usuario_mod,
					fecha_mod
		          	) values(
					'activo',
        		    v_id_sigep_cont_s,
					v_registros.gestion,
					v_registros.clase_gasto::int8,
					v_registros.moneda,
					v_datos_sigep.monto,
					v_registros.id_ptogto,
					v_registros.monto,
					'4',	--v_parametros.tipo_doc_rdo
					v_registros.id_int_comprobante,	--v_parametros.nro_doc_rdo,
					'1',	--v_parametros.sec_doc_rdo,
					v_registros.fecha, --fecha_elaboracion
					upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
		            v_registros.id_beneficiario,
		            v_registros.banco_benef,
		            v_registros.cuenta_benef,
		            v_registros.id_fuente,
        		    v_registros.id_organismo,
		            v_registros.banco,
        		    v_registros.cuenta,
		            v_registros.libreta,
		            v_registros.liquido_pagable,
                    v_registros.multas,
                    v_registros.retenciones,
                    v_registros.liquido_pagable,
					p_id_usuario,
					now(),
					v_parametros._id_usuario_ai,
					v_parametros._nombre_usuario_ai,
					null,
					null
		           );
           			 ---------actualizacion de C31 PREVENTIVO---------
		            /*update conta.tint_comprobante
        			set c31 = v_registros.nro_preventivo,
            		fecha_c31 = v_registros.fecha
		        	where id_int_comprobante = v_parametros.id_int_comprobante;*/
                END IF;

            END LOOP;
          END LOOP;

          select array_to_string(v_id_sigep_regu_s,',','*')
          into v_array_str;
       	--raise exception 'llega:%', v_parametros.momento;


          	-- si hay mas de un estado disponible  preguntamos al usuario
          	v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
          	v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


          	-- Devuelve la respuesta
          	return v_resp;


     end;


   /*********************************
 	#TRANSACCION:  'SIGEP_REGU_CHAR'
 	#DESCRIPCION:	carga datos del siguiente estado de Cbte Contabilidad para Regularizacion en el Sigep
 	#AUTOR:		rzabala
 	#FECHA:		16-05-2019 15:32:51
	***********************************/

	elseif(p_transaccion='SIGEP_REGU_CHAR')then
        begin
        raise exception 'LLEGO AL SERVICIO SIGEP REGULARIZAR: %', v_parametros.momento;
        v_i = 1;
        --v_array_str = '';

       	FOR v_datos_sigep in ( SELECT  cob.nro_tramite,
        								tcg.nombre,
        								scg.clase_gasto,
                						to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                						sum(tra.importe_gasto) as monto
        						FROM conta.tint_comprobante cob
        							INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
        							INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
							      	INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
							        INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tra.id_centro_costo
							        INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
							      	INNER JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
							        INNER JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
							        inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
							        inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
							        inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto

							        INNER JOIN param.tgestion ges ON ges.id_gestion = vcp.id_gestion
						        WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf

							        group by cob.nro_tramite, scg.clase_gasto, tcg.nombre)loop



        insert into sigep.tsigep_adq(
			estado_reg,
			num_tramite,
			estado,
			momento,
			ultimo_mensaje,
			clase_gasto,
            nro_preventivo,
            nro_comprometido,
            nro_devengado,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_datos_sigep.nro_tramite,
			'pre-registro',
			v_parametros.momento,
			'',
			v_datos_sigep.nombre,
            null,
            null,
            null,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_sigep_adq into v_id_sigep_cont_s;
            v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
            --raise exception 'llega:%',  v_id_sigep_cont_s;
            v_array_str:=v_id_sigep_cont_s;
            --raise exception 'llega:%',  v_array_str;
            v_i = v_i+1;


       for v_registros in (	SELECT  cob.id_int_comprobante,
        							cob.nro_tramite,
        							cob.glosa1,
					                cue.nro_cuenta,
					                par.codigo,
					                cc.id_centro_costo,
                                    scba.banco,
					                scba.cuenta,
					                to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
					                pregas.id_ptogto,
					                pregas.id_fuente,
					                pregas.id_organismo,
					                smo.moneda,
					                cp.id_categoria_programatica,
					                cp.codigo_categoria,
					                par.id_partida,
					                scg.clase_gasto,
					                scg.desc_clase_gasto,
					                sum(transa.importe_gasto) as monto,
                                    ges.gestion
						       FROM conta.tint_comprobante cob
					        	inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
					            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
								left join pre.tpartida par on par.id_partida = transa.id_partida
								left join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
								left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
					            left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
					            left join conta.tsuborden suo on suo.id_suborden =  transa.id_suborden
					            left join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
					            inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
					            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
					        	inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
					            inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
					            inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
					            inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto
                                LEFT JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = transa.id_cuenta_bancaria
        						left JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

					            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
						       WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf

						       group by cob.id_int_comprobante, cob.glosa1,cue.nro_cuenta, par.codigo, cc.id_centro_costo, pregas.id_ptogto,
						                pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
						                par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, ges.gestion)loop

       		if (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then
        		insert into sigep.tsigep_adq_det(
            		estado_reg,
		            id_sigep_adq,
					gestion,
					clase_gasto_cip,
					moneda,
					total_autorizado_mo,
					id_ptogto,
					monto_partida,
					tipo_doc_rdo,
					nro_doc_rdo,
					sec_doc_rdo,
					fecha_elaboracion,
					justificacion,
		            beneficiario,
		            banco_benef,
		            cuenta_benef,
		            id_fuente,
		            id_organismo,
		            banco_origen,
		            cta_origen,
		            libreta_origen,
		            monto_benef,
					id_usuario_reg,
					fecha_reg,
					id_usuario_ai,
					usuario_ai,
					id_usuario_mod,
					fecha_mod
		          	) values(
					'activo',
        		    v_id_sigep_cont_s,
					v_registros.gestion,
					v_registros.clase_gasto::int8,
					v_registros.moneda,
					v_datos_sigep.monto,
					v_registros.id_ptogto,
					v_registros.monto,
					'74',	--v_parametros.tipo_doc_rdo
					v_registros.id_int_comprobante,	--v_parametros.nro_doc_rdo,
					'1',	--v_parametros.sec_doc_rdo,
					v_registros.fecha, --fecha_elaboracion
					upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
		            '83797',
		            '',
		            '',
		            v_registros.id_fuente,
        		    v_registros.id_organismo,
		            v_registros.banco,
        		    v_registros.cuenta,
		            '',
		            v_datos_sigep.monto,
					p_id_usuario,
					now(),
					v_parametros._id_usuario_ai,
					v_parametros._nombre_usuario_ai,
					null,
					null
		           );
           			 ---------actualizacion de C31 PREVENTIVO---------
		            /*update conta.tint_comprobante
        			set c31 = v_registros.nro_preventivo,
            		fecha_c31 = v_registros.fecha
		        	where id_int_comprobante = v_parametros.id_int_comprobante;*/
                END IF;

            END LOOP;
          END LOOP;

          select array_to_string(v_id_sigep_regu_s,',','*')
          into v_array_str;
       	--raise exception 'llega:%', v_parametros.momento;


          	-- si hay mas de un estado disponible  preguntamos al usuario
          	v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
          	v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


          	-- Devuelve la respuesta
          	return v_resp;


     end;

	/*********************************
 	#TRANSACCION:  'SIGEP_SIP_CHAR'
 	#DESCRIPCION:	Insertar Parametros Sip a Monitor de Servicios Sigep
 	#AUTOR:		rzabala
 	#FECHA:		13-09-2019 16:50:47
	***********************************/

	elsif(p_transaccion='SIGEP_SIP_CHAR')then

		begin
        --raise exception 'llego comprobante:%', v_parametros.id_int_comprobante;
			--Sentencia de la modificacion
             v_i = 1;
        --v_array_str = '';

       	FOR v_datos_sigep in (select cob.nro_tramite,
										tcg.nombre,
                                        tcc.cuenta_contable,
        								scg.clase_gasto,
        								to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
        								sum(tra.importe_gasto) as monto
       							 FROM conta.tint_comprobante cob
         							INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
         							INNER JOIN conta.tcuenta tcu ON tcu.id_cuenta = tra.id_cuenta
		 							INNER JOIN pre.tclase_gasto_cuenta tcgc ON tcgc.id_cuenta = tcu.id_cuenta
		 							INNER JOIN pre.tpresupuesto tp ON tp.id_presupuesto = tra.id_centro_costo
		 							INNER JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgc.id_clase_gasto
		 							INNER JOIN sigep.tclase_gasto_sip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
         							left join sigep.tcuenta_contable tcc on tcc.id_cuenta = tcu.id_cuenta
         							left join tes.tplan_pago tpp on tpp.id_int_comprobante = tra.id_int_comprobante

         							WHERE cob.id_int_comprobante = v_parametros.id_int_comprobante
         							group by cob.nro_tramite, scg.clase_gasto, tcg.nombre,tcc.cuenta_contable )loop

        if(v_datos_sigep.monto <> '0')then
            insert into sigep.tsigep_adq(
			estado_reg,
			num_tramite,
			estado,
			momento,
			ultimo_mensaje,
			clase_gasto,
            nro_preventivo,
            nro_comprometido,
            nro_devengado,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_datos_sigep.nro_tramite,
			'pre-registro',
			v_parametros.momento,
			'',
			v_datos_sigep.nombre,
            null,
            null,
            null,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_sigep_adq into v_id_sigep_cont_s;
            v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
            --raise exception 'llega:%',  v_id_sigep_cont_s;
            v_array_str:=v_id_sigep_cont_s;
            --raise exception 'llega:%',  v_array_str;
            v_i = v_i+1;

             for v_registros in (SELECT to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
        								sum(tra.importe_gasto) as monto,
						        		tcc.cuenta_contable,
						        		tpp.monto,
                                        ges.gestion,
						                scg.clase_gasto,
						                scg.desc_clase_gasto,
						                tcg.codigo,
						                cob.id_int_comprobante,
						                top.id_proveedor,
						                tpro.id_beneficiario,
						                tpp.id_proveedor_cta_bancaria,
						                tpcb.nro_cuenta,
						                tban.banco as banco_benef,
						                cob.nro_tramite,
						                cob.glosa1,
						                tmo.moneda,
						                top.total_pago,
                                        tpp.liquido_pagable,
						                tlib.cuenta,
						                tlib.banco,
						                tlib.libreta
        							FROM conta.tint_comprobante cob
							         INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
							         left JOIN conta.tcuenta tcu ON tcu.id_cuenta = tra.id_cuenta
									 INNER JOIN pre.tclase_gasto_cuenta tcgc ON tcgc.id_cuenta = tcu.id_cuenta
									 INNER JOIN pre.tpresupuesto tp ON tp.id_presupuesto = tra.id_centro_costo
									 INNER JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgc.id_clase_gasto
									 INNER JOIN sigep.tclase_gasto_sip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
							         left join sigep.tcuenta_contable tcc on tcc.id_cuenta = tcgc.id_cuenta
									 left JOIN tes.tplan_pago tpp ON tpp.id_int_comprobante = cob.id_int_comprobante
							         left JOIN tes.tobligacion_pago top ON top.id_obligacion_pago = tpp.id_obligacion_pago
							         INNER JOIN param.tproveedor tpro ON tpro.id_proveedor = top.id_proveedor
							         INNER JOIN sigep.tmoneda tmo ON tmo.id_moneda = cob.id_moneda
							         inner join param.tproveedor_cta_bancaria tpcb on tpcb.id_proveedor_cta_bancaria = tpp.id_proveedor_cta_bancaria
							         inner join tes.tcuenta_bancaria tcb on tcb.id_cuenta_bancaria = tpp.id_cuenta_bancaria
							         inner join param.tinstitucion tins on tins.id_institucion = tcb.id_institucion
							         inner join sigep.tbanco tban on tban.id_institucion = tpcb.id_banco_beneficiario --and tban.id_institucion = tins.id_institucion
							         left join sigep.tlibreta tlib on tlib.id_cuenta_bancaria = tcb.id_cuenta_bancaria
							         INNER JOIN param.tgestion ges ON ges.id_gestion = tcu.id_gestion

									WHERE cob.id_int_comprobante = v_parametros.id_int_comprobante

							        group by tcc.cuenta_contable, tpp.monto, scg.clase_gasto, ges.gestion, tpp.liquido_pagable,
							                scg.desc_clase_gasto,tcg.codigo, cob.id_int_comprobante, top.id_proveedor, tpro.id_beneficiario,
							                tpp.id_proveedor_cta_bancaria, tpcb.nro_cuenta, tban.banco, cob.nro_tramite,
							                cob.glosa1, tmo.moneda, top.total_pago, tlib.cuenta, tlib.banco, tlib.libreta)LOOP

        if (v_datos_sigep.clase_gasto = v_registros.clase_gasto)then

        	if(EXISTS(select 1
            			FROM sigep.tsigep_adq_det sad
						 INNER JOIN sigep.tsigep_adq sa on sa.id_sigep_adq = sad.id_sigep_adq
                        where sad.clase_gasto_cip = v_datos_sigep.clase_gasto and sad.cuenta_contable = v_registros.cuenta_contable))then


            insert into sigep.tsigep_adq_det(
            		estado_reg,
		            id_sigep_adq,
					gestion,
					clase_gasto_cip,
					moneda,
					total_autorizado_mo,
					id_ptogto,
					monto_partida,
					tipo_doc_rdo,
					nro_doc_rdo,
					sec_doc_rdo,
					fecha_elaboracion,
					justificacion,
		            beneficiario,
		            banco_benef,
		            cuenta_benef,
		            id_fuente,
		            id_organismo,
		            banco_origen,
		            cta_origen,
		            libreta_origen,
		            monto_benef,
                    multa,
                    retencion,
                    liquido_pagable,
                    cuenta_contable,
                    sisin,
                    otfin,
					id_usuario_reg,
					fecha_reg,
					id_usuario_ai,
					usuario_ai,
					id_usuario_mod,
					fecha_mod
		          	) values(
					'activo',
        		    v_id_sigep_cont_s,
					v_registros.gestion,
					v_registros.clase_gasto::int8,
					v_registros.moneda,
					v_registros.monto,
					null,
					v_registros.monto,
					'74',	--v_parametros.tipo_doc_rdo
					v_registros.id_int_comprobante,	--v_parametros.nro_doc_rdo,
					'1',	--v_parametros.sec_doc_rdo,
					v_registros.fecha, --fecha_elaboracion
					upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
		            v_registros.id_beneficiario,
		            v_registros.banco_benef,
		            v_registros.nro_cuenta,
		            '',
        		    '',
		            v_registros.banco,
        		    v_registros.cuenta,
		            v_registros.libreta,
		            v_datos_sigep.monto,
                    '0',
                    '0',
                    v_registros.liquido_pagable,
                    v_registros.cuenta_contable,
                    '',
                    '',
					p_id_usuario,
					now(),
					v_parametros._id_usuario_ai,
					v_parametros._nombre_usuario_ai,
					null,
					null
		           );
                   end if;
             END IF;

            END LOOP;
         end if;
        END LOOP;
        select array_to_string(v_id_sigep_regu_s,',','*')
          into v_array_str;

       	--raise exception 'llega:%', v_parametros.momento;


          	--Definicion de la respuesta
          	v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
          	v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_SAD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rzabala
 	#FECHA:		25-03-2019 15:50:47
	***********************************/

	elsif(p_transaccion='SIGEP_SAD_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tsigep_adq_det set
            id_sigep_adq = v_parametros.id_sigep_adq,
			gestion = v_parametros.gestion,
			clase_gasto_cip = v_parametros.clase_gasto_cip,
			moneda = v_parametros.moneda,
			total_autorizado_mo = v_parametros.total_autorizado_mo,
			id_ptogto = v_parametros.id_ptogto,
			monto_partida = v_parametros.monto_partida,
			tipo_doc_rdo = v_parametros.tipo_doc_rdo,
			nro_doc_rdo = v_parametros.nro_doc_rdo,
			sec_doc_rdo = v_parametros.sec_doc_rdo,
			fecha_elaboracion = v_parametros.fecha_elaboracion,
			justificacion = v_parametros.justificacion,
            id_fuente = v_parametros.id_fuente,
            id_organismo = v_parametros.id_organismo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_sigep_adq_det=v_parametros.id_sigep_adq_det;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep Adquisiciones Detalle modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq_det',v_parametros.id_sigep_adq_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_SAD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rzabala
 	#FECHA:		25-03-2019 15:50:47
	***********************************/

	elsif(p_transaccion='SIGEP_SAD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tsigep_adq_det
            where id_sigep_adq_det=v_parametros.id_sigep_adq_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep Adquisiciones Detalle eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq_det',v_parametros.id_sigep_adq_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION

	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION sigep.ft_sigep_adq_det_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;