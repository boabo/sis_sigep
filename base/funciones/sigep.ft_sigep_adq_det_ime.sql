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
    v_id_sigep_cont_s		numeric;
    map_moneda				numeric;
    v_record				record;
    v_fecha					date;
    v_momento	            varchar;
    v_preventivo     		record;
    cuenta_apro				varchar;
    v_nro_tramite			varchar;
    v_total					numeric;

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
                INNER JOIN param.tmoneda tmo ON tmo.id_moneda = ts.id_moneda

				WHERE tsd.estado_reg = 'activo' AND ts.id_proceso_wf = v_parametros.id_proceso_wf_act::int8
 				group by 	tcg.codigo, tcg.nombre,	ts.num_tramite, tmo.id_moneda;

            --raise exception 'DATOS SERVICIO SIGEP: %', v_datos_sigep;


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

      /*********************************
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