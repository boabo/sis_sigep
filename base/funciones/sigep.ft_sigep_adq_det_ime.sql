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
    v_i						integer;
    v_aprobador				varchar;
    v_firmador				varchar;
    v_user					integer;

    -- VARIABLES RCIVA
    v_monto_total_prorra	numeric;
    v_monto_total			numeric;
    v_cont_doc				integer;
    v_monto_total_auth		numeric;
    v_inner 				varchar = '';
    v_campo					varchar = '';
    v_nro_preventivo		integer;
    v_nro_comprometido		integer;
    v_nro_devengado			integer;
    v_id_int_comprobante	integer;
    v_diferencia_redondeo	numeric = 0;
    v_monto_verficador		numeric = 0;
    v_monto_partida			numeric = 0;
    v_monto_rciva			numeric = 0;
    v_flag_rciva			boolean = true;

    v_id_proceso_wf			integer;
    v_id_entrega_original	integer;

    v_deposito				record;

    v_tipo_trans			varchar;

    v_retencion				numeric = 0;
    v_retencion_header		numeric = 0;
    v_retencion_expand		record;

    v_retencion_value		numeric = 0;

    v_beneficiario          record;
    v_lista_beneficiario    jsonb = '[]'::jsonb;

    v_diferencia_partida	numeric = 0;
    v_diferencia_header 	numeric = 0;

    v_total_partida			numeric = 0;
    v_cantidad_partida		integer = 0;
    v_contador_partida		integer = 0;
    v_total_autorizado      numeric = 0;
    v_diferencia_centavo	numeric = 0;
    v_diff_redondeo			numeric = 0;

    v_suma_ejecucion		numeric = 0;

    v_sumatoria_partida		numeric = 0;

    v_validar_programa		record;
    v_validar_contador		integer = 0;

    v_ret_count 			integer = 0;

    v_id_depto				integer;
    v_valor_programa		integer = 1;

    v_contador				integer = 1;

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
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tint_comprobante
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;
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
                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;--(select us.cuenta
                --from  segu.vusuario us
                --where us.id_usuario = v_record_sol.id_usuario_reg);
                END IF;
                IF(v_record.codigo = 'vbconta')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'vbfin')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;

            FOR v_datos_sigep in SELECT  cob.nro_tramite,
                                         tcg.nombre,
                                         scg.clase_gasto,
                                         to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                         sum(tra.importe_gasto + tra.importe_reversion) as monto,
                                         cob.id_int_comprobante,
                                         cob.fecha fecha_tipo_cambio

                                 FROM conta.tint_comprobante cob
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                          INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                          INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tra.id_centro_costo
                                          INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                          inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                          inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                          inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
                                          inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                          left join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                          left join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                          inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                      --INNER JOIN param.tgestion ges ON ges.id_gestion = vcp.id_gestion
                                      --inner join tes.tplan_pago tpp on tpp.id_int_comprobante = cob.id_int_comprobante
                                 WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by cob.nro_tramite, scg.clase_gasto, tcg.nombre, cob.id_int_comprobante/*, tpar.id_partida*/ loop

                select count(tdcv.id_doc_compra_venta)
                into v_cont_doc
                from conta.tint_comprobante tcom
                         inner join conta.tdoc_compra_venta tdcv on tdcv.id_int_comprobante = tcom.id_int_comprobante
                where tcom.id_proceso_wf = v_parametros.id_proceso_wf and tdcv.id_plantilla = 1;
                --raise 'v_cont_doc: %', v_cont_doc;
                v_monto_total = v_datos_sigep.monto; --raise 'v_monto_total: %', v_monto_total;
                if v_cont_doc > 0 then
                    select sum(tp.monto_ejecutar_mo) - tpp.descuento_ley
                    into v_monto_total
                    from conta.tint_comprobante tc
                             inner join tes.tplan_pago tpp on tpp.id_int_comprobante = tc.id_int_comprobante
                             inner join tes.tprorrateo tp on tp.id_plan_pago = tpp.id_plan_pago
                    where tc.id_int_comprobante = v_datos_sigep.id_int_comprobante
                    group by tpp.descuento_ley;

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
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;

                for v_registros in SELECT  cob.id_int_comprobante,
                                           cob.nro_tramite,
                                           cob.glosa1,
                                           --cue.nro_cuenta,
                                           par.codigo,
                                           --cc.id_centro_costo,
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
                                           sum(transa.importe_gasto) + sum(transa.importe_reversion) as monto,
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
                                           ges.gestion,
                                           tpla.id_plan_pago,
                                           transa.factor_reversion,
                                           tpla.descuento_inter_serv,
                                           tpla.descuento_ley,
                                           mul.codigo as cod_multa,
                                           pregas.id_catpry as sisin
                                   FROM conta.tint_comprobante cob
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                            inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
                                            inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                            inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
                                            inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
                                            inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                            inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                            inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente

                                            inner join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante

                                            LEFT JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                            left JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                            inner join param.tproveedor_cta_bancaria proc on proc.id_proveedor_cta_bancaria = tpla.id_proveedor_cta_bancaria
                                            inner join param.tproveedor tpro on tpro.id_proveedor = proc.id_proveedor
                                            inner join sigep.tbanco ban on ban.id_institucion = proc.id_banco_beneficiario
                                            inner join sigep.tlibreta lib on lib.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                            left join sigep.tmulta mul on mul.id_multa = tpla.id_multa
                                            inner JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            inner JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf /*AND par.id_partida = v_datos_sigep.id_partida*/

                                   group by cob.id_int_comprobante, cob.glosa1, par.codigo, pregas.id_ptogto,
                                            pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                            par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, tpro.id_beneficiario,
                                            ban.banco, proc.nro_cuenta, tpla.monto, lib.banco, lib.cuenta, lib.libreta,ges.gestion, mul.codigo,pregas.id_catpry,
                                            tpla.otros_descuentos, tpla.monto_retgar_mo, tpla.liquido_pagable, tpla.id_plan_pago, transa.factor_reversion, tpla.descuento_ley loop

                    v_monto_total_prorra = v_registros.monto;
                    --v_monto_total_prorra =  v_registros.monto + ((v_registros.monto * 0.13)/0.87);
                    --end if;
                    v_monto_total_auth = v_monto_total; --raise 'totales: %, %', v_monto_total_auth, v_registros.retenciones;
                    if v_registros.retenciones > 0 then
                        v_monto_total_prorra = v_monto_total_prorra * 0.93;
                        v_monto_total_auth = v_monto_total_auth - v_registros.retenciones;
                    end if;

                    if v_registros.descuento_inter_serv > 0 then
                        v_monto_total_prorra = v_monto_total_prorra - v_registros.descuento_inter_serv;
                        v_monto_total_auth = v_monto_total_auth - v_registros.descuento_inter_serv;
                    end if;

                    if v_registros.descuento_ley > 0 then
                        v_monto_total_prorra = v_monto_total_prorra - v_registros.descuento_ley;
                    end if;

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
                            usuario_apro,
                            multa,
                            retencion,
                            liquido_pagable,
                            sisin,
                            otfin,
                            usuario_firm,
                            cod_multa,
                            id_usuario_reg,
                            fecha_reg,
                            id_usuario_ai,
                            usuario_ai,
                            id_usuario_mod,
                            fecha_mod,
                            fecha_tipo_cambio
                        ) values(
                                    'activo',
                                    v_id_sigep_cont_s,
                                    v_registros.gestion,
                                    v_registros.clase_gasto::int8,
                                    v_registros.moneda,
                                    v_monto_total_auth,--v_datos_sigep.monto,
                                    v_registros.id_ptogto,
                                    v_monto_total_prorra,--v_registros.monto,
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
                                    v_aprobador,
                                    v_registros.multas,
                                    v_registros.retenciones,
                                    v_registros.liquido_pagable,
                                    v_registros.sisin,
                                    '',
                                    v_firmador,
                                    v_registros.cod_multa,
                                    v_user,
                                    now(),
                                    v_parametros._id_usuario_ai,
                                    v_parametros._nombre_usuario_ai,
                                    null,
                                    null,
                                    v_datos_sigep.fecha_tipo_cambio
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

            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


            -- Devuelve la respuesta
            return v_resp;


        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_ENT_CIP_CHAR'
 	#DESCRIPCION:	C31 Normales para envio a Sigep CIP
 	#AUTOR:		franklin.espinoza
 	#FECHA:		15-10-2020 15:32:51
	***********************************/

    elseif(p_transaccion='SIGEP_ENT_CIP_CHAR')then
        begin
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tentrega
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;
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
                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;
                IF(v_record.codigo = 'vbconta')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'vbfin')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;
            select tus.cuenta
            into v_aprobador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'verificado';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'aprobado';


            FOR v_datos_sigep in SELECT   tcg.nombre,
                                          scg.clase_gasto,
                                          to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                          sum(tra.importe_gasto + tra.importe_reversion) as monto,
                                          te.id_entrega,
                                          cob.fecha fecha_tipo_cambio,
                                          cob.localidad
                                 FROM conta.tentrega te
                                          inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                          inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                          INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                          INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tra.id_centro_costo
                                          INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                          inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                          inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                          inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica
                                          inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                          left join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                          left join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                          inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                 WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by tcg.nombre, scg.clase_gasto, te.id_entrega, fecha_tipo_cambio, cob.localidad loop

                IF v_datos_sigep.monto != 0 THEN
                    select cob.nro_tramite, ted.id_int_comprobante, cob.id_proceso_wf
                    into v_nro_tramite, v_id_int_comprobante, v_id_proceso_wf
                    from conta.tentrega te
                             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                             inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                    where te.id_entrega = v_datos_sigep.id_entrega
                    limit 1;

                    select count(tdcv.id_doc_compra_venta)
                    into v_cont_doc
                    from conta.tint_comprobante tcom
                             inner join conta.tdoc_compra_venta tdcv on tdcv.id_int_comprobante = tcom.id_int_comprobante
                    where tcom.id_proceso_wf = v_id_proceso_wf and tdcv.id_plantilla = 1;--v_parametros.id_proceso_wf

                    select sum(case when ts.importe_recurso !=0 then ts.importe_recurso else ts.importe_gasto_mt end )
                    into v_diferencia_redondeo
                    from conta.tint_transaccion ts
                    where ts.id_int_comprobante = v_id_int_comprobante and ts.id_detalle_plantilla_comprobante is null;

                    select  (case when ts.importe_debe_mt != 0 then 'debe' else 'haber' end)::varchar tipo
                    into v_tipo_trans
                    from conta.tint_transaccion ts
                    where ts.id_int_comprobante = v_id_int_comprobante
                      and ts.id_detalle_plantilla_comprobante is null;

                    if v_diferencia_redondeo > 0 and  v_tipo_trans = 'haber' then
                        v_monto_total = v_datos_sigep.monto-v_diferencia_redondeo;
                    else
                        v_monto_total = v_datos_sigep.monto;
                    end if;
                    if v_cont_doc > 0 then
                        select sum(tp.monto_ejecutar_mo) - tpp.descuento_ley
                        into v_monto_total
                        from conta.tint_comprobante tc
                                 inner join tes.tplan_pago tpp on tpp.id_int_comprobante = tc.id_int_comprobante
                                 inner join tes.tprorrateo tp on tp.id_plan_pago = tpp.id_plan_pago
                        where tc.id_int_comprobante = v_id_int_comprobante--v_datos_sigep.id_entrega
                        group by tpp.descuento_ley;
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
                        localidad,
                        id_usuario_reg,
                        fecha_reg,
                        id_usuario_ai,
                        usuario_ai,
                        id_usuario_mod,
                        fecha_mod,
                        id_int_comprobante
                    ) values(
                                'activo',
                                v_nro_tramite,
                                'pre-registro',
                                v_parametros.momento,
                                '',
                                v_datos_sigep.nombre,
                                null,
                                null,
                                null,
                                v_datos_sigep.localidad,
                                p_id_usuario,
                                now(),
                                v_parametros._id_usuario_ai,
                                v_parametros._nombre_usuario_ai,
                                null,
                                null,
                                v_datos_sigep.id_entrega
                            )RETURNING id_sigep_adq into v_id_sigep_cont_s;

                    v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                    v_array_str:=v_id_sigep_cont_s;
                    v_i = v_i+1;

                    /************************************ Sumatoria Partida **********************************/
                    for v_registros in SELECT  te.id_entrega
                                       FROM conta.tentrega te
                                                inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                                inner join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante
                                                inner join tes.tprorrateo tpror on tpror.id_plan_pago = tpla.id_plan_pago
                                                inner join conta.tint_transaccion transa on transa.id_int_transaccion = tpror.id_int_transaccion

                                                inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                                inner join pre.tpartida par on par.id_partida = transa.id_partida
                                                inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                                inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                                inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                                inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
                                                inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                                inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                                inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
                                                inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                                inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                                inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                                inner join tes.tobligacion_pago top on top.id_obligacion_pago = tpla.id_obligacion_pago
                                                LEFT JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                                left JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                                inner join param.tproveedor_cta_bancaria proc on proc.id_proveedor_cta_bancaria = tpla.id_proveedor_cta_bancaria
                                                inner join param.tproveedor tpro on tpro.id_proveedor = proc.id_proveedor
                                                inner join sigep.tbanco ban on ban.id_institucion = proc.id_banco_beneficiario
                                                inner join sigep.tlibreta lib on lib.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                                left join sigep.tmulta mul on mul.id_multa = tpla.id_multa
                                                inner JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                                inner JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                       WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                       group by  te.id_entrega, cob.glosa1, par.codigo, pregas.id_ptogto,
                                                 pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                                 par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, tpro.id_beneficiario,
                                                 ban.banco, proc.nro_cuenta, tpla.monto, lib.banco, lib.cuenta, lib.libreta,ges.gestion, mul.codigo,pregas.id_catpry,
                                                 tpla.otros_descuentos, tpla.monto_retgar_mo, tpla.liquido_pagable, tpla.id_plan_pago, transa.factor_reversion,
                                                 top.nro_preventivo, tpla.descuento_ley loop
                        v_cantidad_partida = v_cantidad_partida + 1;
                    end loop;

                    /************************************ Sumatoria Partida **********************************/
                    for v_registros in SELECT  te.id_entrega,
                                               te.glosa,
                                               par.codigo,
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
                                               --sum(transa.importe_gasto) /*+ sum(transa.importe_reversion)*/ as monto,
                                               sum(tpror.monto_ejecutar_mo) as monto,
                                               tpla.liquido_pagable,
                                               tpro.id_beneficiario,
                                               ban.banco as banco_benef,
                                               trim(proc.nro_cuenta) as cuenta_benef,
                                               tpla.liquido_pagable as monto_benef,
                                               tpla.otros_descuentos as multas,
                                               tpla.monto_retgar_mo as retenciones,
                                               lib.banco,
                                               lib.cuenta,
                                               lib.libreta,
                                               ges.gestion,
                                               tpla.id_plan_pago,
                                               transa.factor_reversion,
                                               tpla.descuento_inter_serv,
                                               tpla.descuento_ley,
                                               mul.codigo as cod_multa,
                                               pregas.id_catpry as sisin,
                                               top.nro_preventivo,
                                               round(tpla.porc_monto_retgar,3) porcentaje_retencion
                                       FROM conta.tentrega te
                                                inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                           --inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                                inner join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante
                                                inner join tes.tprorrateo tpror on tpror.id_plan_pago = tpla.id_plan_pago
                                                inner join conta.tint_transaccion transa on transa.id_int_transaccion = tpror.id_int_transaccion

                                                inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                                inner join pre.tpartida par on par.id_partida = transa.id_partida
                                                inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                                inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                                inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                                inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
                                                inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                                inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                                inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
                                                inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                                inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                                inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente

                                           --inner join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante
                                                inner join tes.tobligacion_pago top on top.id_obligacion_pago = tpla.id_obligacion_pago

                                                LEFT JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                                left JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                                inner join param.tproveedor_cta_bancaria proc on proc.id_proveedor_cta_bancaria = tpla.id_proveedor_cta_bancaria
                                                inner join param.tproveedor tpro on tpro.id_proveedor = proc.id_proveedor
                                                inner join sigep.tbanco ban on ban.id_institucion = proc.id_banco_beneficiario
                                                inner join sigep.tlibreta lib on lib.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                                left join sigep.tmulta mul on mul.id_multa = tpla.id_multa
                                                inner JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                                inner JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                       WHERE te.id_proceso_wf = v_parametros.id_proceso_wf

                                       group by  te.id_entrega, cob.glosa1, par.codigo, pregas.id_ptogto,
                                                 pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                                 par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, tpro.id_beneficiario,
                                                 ban.banco, proc.nro_cuenta, tpla.monto, lib.banco, lib.cuenta, lib.libreta,ges.gestion, mul.codigo,pregas.id_catpry,
                                                 tpla.otros_descuentos, tpla.monto_retgar_mo, tpla.liquido_pagable, tpla.id_plan_pago, transa.factor_reversion,
                                                 top.nro_preventivo, tpla.descuento_ley loop


                        v_monto_total_prorra = v_registros.monto;
                        v_monto_partida = v_monto_total_prorra;
                        --v_monto_total_prorra =  v_registros.monto + ((v_registros.monto * 0.13)/0.87);
                        --end if;

                        SELECT   sum(tra.importe_recurso)
                        into v_diff_redondeo
                        FROM conta.tentrega te
                                 inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                 inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                 INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                        WHERE te.id_proceso_wf = v_parametros.id_proceso_wf  and tra.id_detalle_plantilla_comprobante is null and tra.importe_recurso_mt = 0;

                        SELECT sum(tpror.monto_ejecutar_mo)
                        into v_suma_ejecucion
                        FROM conta.tentrega te
                                 inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                 inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                 inner join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante
                                 inner join tes.tprorrateo tpror on tpror.id_plan_pago = tpla.id_plan_pago
                        WHERE te.id_proceso_wf = v_parametros.id_proceso_wf;

                        if v_diff_redondeo > 0 and v_monto_total != v_suma_ejecucion then
                            if v_monto_total > v_suma_ejecucion then
                                v_monto_total_auth = v_monto_total - v_diff_redondeo;
                            elsif v_monto_total < v_suma_ejecucion then
                                v_monto_total_auth = v_monto_total + v_diff_redondeo;
                            end if;
                        else
                            if v_monto_total >= v_registros.liquido_pagable then
                                v_monto_total_auth = v_registros.liquido_pagable;
                            else
                                v_monto_total_auth = v_monto_total; --raise 'totales: %, %', v_monto_total_auth, v_registros.retenciones;
                            end if;
                        end if;

                        if v_registros.retenciones > 0 then

                            /*if v_monto_total_prorra - v_registros.retenciones = v_registros.liquido_pagable then
                              v_monto_total_prorra = v_monto_total_prorra - v_registros.retenciones;
                          else*/
                            v_monto_total_prorra = v_monto_total_prorra * coalesce(v_registros.porcentaje_retencion, 0.93);
                            v_monto_total_prorra = v_monto_partida - v_monto_total_prorra;
                            --end if;

                            --begin verificar redondeo
                            if round(v_monto_total_prorra,2) + v_monto_verficador <= v_registros.liquido_pagable then
                                v_monto_verficador = v_monto_verficador + round(v_monto_total_prorra,2);
                                v_monto_partida = round(round(round(v_monto_total_prorra,4),3),2);
                            else
                                v_monto_verficador = v_monto_verficador + trunc(v_monto_total_prorra,2);
                                v_monto_partida = trunc(v_monto_total_prorra,2);
                            end if;
                            --end

                            if v_monto_total_auth - v_registros.retenciones <= v_registros.liquido_pagable then
                                v_monto_total_auth = v_registros.liquido_pagable;
                            else
                                v_monto_total_auth = v_monto_total_auth - v_registros.retenciones;
                            end if;

                        end if;

                        if v_registros.descuento_inter_serv > 0 then
                            --v_monto_total_prorra = v_monto_total_prorra - v_registros.descuento_inter_serv;
                            v_monto_partida = v_monto_partida - v_registros.descuento_inter_serv;
                            v_monto_total_auth = v_monto_total_auth - v_registros.descuento_inter_serv;
                        end if;

                        if v_registros.descuento_ley > 0 then
                            --v_monto_total_prorra = v_monto_total_prorra - v_registros.descuento_ley;
                            v_monto_partida = v_monto_partida - v_registros.descuento_ley;
                        end if;


                        v_sumatoria_partida = v_sumatoria_partida + v_monto_partida;
                        v_contador_partida = v_contador_partida + 1;

                        if v_contador_partida = v_cantidad_partida then
                            if v_registros.monto_benef > v_sumatoria_partida then
                                v_diferencia_centavo = v_registros.monto_benef - v_sumatoria_partida;
                                v_monto_partida =  v_monto_partida + v_diferencia_centavo;
                            elsif v_registros.monto_benef < v_sumatoria_partida then
                                v_diferencia_centavo = v_sumatoria_partida - v_registros.monto_benef;
                                v_monto_partida =  v_monto_partida - v_diferencia_centavo;
                            end if;
                        end if;

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
                                usuario_apro,
                                multa,
                                retencion,
                                liquido_pagable,
                                sisin,
                                otfin,
                                usuario_firm,
                                cod_multa,
                                id_usuario_reg,
                                fecha_reg,
                                id_usuario_ai,
                                usuario_ai,
                                id_usuario_mod,
                                fecha_mod,
                                fecha_tipo_cambio,
                                nro_preventivo
                            ) values(
                                        'activo',
                                        v_id_sigep_cont_s,
                                        v_registros.gestion,
                                        v_registros.clase_gasto::int8,
                                        v_registros.moneda,
                                        v_monto_total_auth,--v_registros.liquido_pagable --v_monto_total_auth,--v_datos_sigep.monto,
                                        v_registros.id_ptogto,
                                        v_monto_partida,--v_monto_total_prorra, --v_registros.monto,
                                        '4',	--v_parametros.tipo_doc_rdo
                                        v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        --upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
                                        v_registros.glosa,
                                        v_registros.id_beneficiario,
                                        v_registros.banco_benef,
                                        v_registros.cuenta_benef,
                                        v_registros.id_fuente,
                                        v_registros.id_organismo,
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        v_registros.libreta,
                                        v_registros.liquido_pagable,
                                        v_aprobador,
                                        v_registros.multas,
                                        v_registros.retenciones,
                                        v_registros.liquido_pagable,
                                        v_registros.sisin,
                                        '',
                                        v_firmador,
                                        v_registros.cod_multa,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_registros.nro_preventivo
                                    );
                        END IF;

                    END LOOP;
                END IF;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*')
            into v_array_str;

            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


            -- Devuelve la respuesta
            return v_resp;


        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_REV_C31_NORMAL'
 	#DESCRIPCION:	carga datos de un grupo de entrega de Contabilidad para Regularizacion en el Sigep
 	#AUTOR:		franklin.espinoza
 	#FECHA:		27-09-2020 12:00:00
	***********************************/

    elseif(p_transaccion='SIGEP_REV_C31_NORMAL')then

        begin
            select id_estado_wf, id_usuario_reg, id_entrega
            into v_record_sol
            from conta.tentrega
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;
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
                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;
                IF(v_record.codigo = 'vbconta')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'vbfin')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;
            select tus.cuenta
            into v_aprobador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'verificado';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'aprobado';

            select ted.id_entrega
            into v_id_entrega_original
            from conta.tentrega_det ed
                     inner join conta.tint_comprobante tic on tic.id_int_comprobante = ed.id_int_comprobante
                     inner join conta.tentrega_det ted on ted.id_int_comprobante = tic.id_int_comprobante_fks[1]::integer
            where ed.id_entrega = v_record_sol.id_entrega;

            select te.nro_deposito, te.fecha_deposito, te.monto_deposito, te.monto
            into v_deposito
            from conta.tentrega te
            where id_proceso_wf = v_parametros.id_proceso_wf;


            FOR v_datos_sigep in SELECT   tcg.nombre,
                                          scg.clase_gasto,
                                          to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                          sum(tra.importe_gasto + tra.importe_reversion) as monto,
                                          te.id_entrega,
                                          cob.fecha fecha_tipo_cambio,
                                          cob.localidad
                                 FROM conta.tentrega te
                                          inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                          inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                          INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                          INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tra.id_centro_costo
                                          INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                          inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                          inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                          inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica
                                          inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                          left join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                          left join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                          inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                 WHERE te.id_entrega = v_id_entrega_original
                                 group by tcg.nombre, scg.clase_gasto, te.id_entrega, fecha_tipo_cambio, cob.localidad loop

                IF v_datos_sigep.monto != 0 THEN
                    select cob.nro_tramite, ted.id_int_comprobante, cob.id_proceso_wf
                    into v_nro_tramite, v_id_int_comprobante, v_id_proceso_wf
                    from conta.tentrega te
                             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                             inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                    where te.id_entrega = v_datos_sigep.id_entrega
                    limit 1;

                    select count(tdcv.id_doc_compra_venta)
                    into v_cont_doc
                    from conta.tint_comprobante tcom
                             inner join conta.tdoc_compra_venta tdcv on tdcv.id_int_comprobante = tcom.id_int_comprobante
                    where tcom.id_proceso_wf = v_id_proceso_wf and tdcv.id_plantilla = 1;--v_parametros.id_proceso_wf

                    select sum(case when ts.importe_recurso !=0 then ts.importe_recurso else ts.importe_gasto_mt end )
                    into v_diferencia_redondeo
                    from conta.tint_transaccion ts
                    where ts.id_int_comprobante = v_id_int_comprobante and ts.id_detalle_plantilla_comprobante is null;

                    if v_diferencia_redondeo > 0 then
                        v_monto_total = v_datos_sigep.monto-v_diferencia_redondeo;
                    else
                        v_monto_total = v_datos_sigep.monto;
                    end if;

                    if v_cont_doc > 0 then
                        select sum(tp.monto_ejecutar_mo) - tpp.descuento_ley
                        into v_monto_total
                        from conta.tint_comprobante tc
                                 inner join tes.tplan_pago tpp on tpp.id_int_comprobante = tc.id_int_comprobante
                                 inner join tes.tprorrateo tp on tp.id_plan_pago = tpp.id_plan_pago
                        where tc.id_int_comprobante = v_id_int_comprobante--v_datos_sigep.id_entrega
                        group by tpp.descuento_ley;
                    end if;

                    select tsa.nro_preventivo , tsa.nro_comprometido, tsa.nro_devengado
                    into v_nro_preventivo, v_nro_comprometido, v_nro_devengado
                    from conta.tentrega ten
                             inner join conta.tentrega_det ted on ted.id_entrega = ten.id_entrega
                             inner join sigep.tsigep_adq tsa on tsa.id_int_comprobante = ted.id_entrega
                    where   ted.id_int_comprobante = (select tic.id_int_comprobante_fks[1]
                                                      from conta.tentrega te
                                                               inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                               inner join conta.tint_comprobante tic on tic.id_int_comprobante = ted.id_int_comprobante
                                                      where te.id_proceso_wf =  v_parametros.id_proceso_wf limit 1) and tsa.nro_preventivo is not null and
                        tsa.nro_comprometido is not null and tsa.nro_devengado is not null
                    limit 1;

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
                        localidad,
                        id_usuario_reg,
                        fecha_reg,
                        id_usuario_ai,
                        usuario_ai,
                        id_usuario_mod,
                        fecha_mod,
                        id_int_comprobante
                    ) values(
                                'activo',
                                v_nro_tramite,
                                'pre-registro',
                                v_parametros.momento,
                                '',
                                v_datos_sigep.nombre,
                                v_nro_preventivo,
                                v_nro_comprometido,
                                v_nro_devengado,
                                v_datos_sigep.localidad,
                                p_id_usuario,
                                now(),
                                v_parametros._id_usuario_ai,
                                v_parametros._nombre_usuario_ai,
                                null,
                                null,
                                v_record_sol.id_entrega
                            )RETURNING id_sigep_adq into v_id_sigep_cont_s;

                    v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                    v_array_str:=v_id_sigep_cont_s;
                    v_i = v_i+1;

                    for v_registros in SELECT  te.id_entrega,
                                               te.glosa,
                                               par.codigo,
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
                                               sum(tpror.monto_ejecutar_mo) monto,
                                               tpla.liquido_pagable liquido_pagable,
                                               tpro.id_beneficiario,
                                               ban.banco as banco_benef,
                                               trim(proc.nro_cuenta) cuenta_benef,
                                               tpla.liquido_pagable monto_benef,
                                               tpla.otros_descuentos multas,
                                               tpla.monto_retgar_mo retenciones,
                                               lib.banco,
                                               lib.cuenta,
                                               lib.libreta,
                                               ges.gestion,
                                               tpla.id_plan_pago,
                                               transa.factor_reversion,
                                               tpla.descuento_inter_serv,
                                               tpla.descuento_ley,
                                               mul.codigo as cod_multa,
                                               pregas.id_catpry as sisin,
                                               top.nro_preventivo,
                                               tpla.porc_monto_retgar


                                       FROM conta.tentrega te
                                                inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                                inner join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante
                                                inner join tes.tprorrateo tpror on tpror.id_plan_pago = tpla.id_plan_pago
                                                inner join conta.tint_transaccion transa on transa.id_int_transaccion = tpror.id_int_transaccion

                                                inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                                inner join pre.tpartida par on par.id_partida = transa.id_partida
                                                inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                                inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                                inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                                inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
                                                inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                                inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                                inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
                                                inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                                inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                                inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente

                                                inner join tes.tobligacion_pago top on top.id_obligacion_pago = tpla.id_obligacion_pago

                                                LEFT JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                                left JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                                inner join param.tproveedor_cta_bancaria proc on proc.id_proveedor_cta_bancaria = tpla.id_proveedor_cta_bancaria
                                                inner join param.tproveedor tpro on tpro.id_proveedor = proc.id_proveedor
                                                inner join sigep.tbanco ban on ban.id_institucion = proc.id_banco_beneficiario
                                                inner join sigep.tlibreta lib on lib.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                                left join sigep.tmulta mul on mul.id_multa = tpla.id_multa
                                                inner JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                                inner JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                       WHERE te.id_entrega = v_id_entrega_original

                                       group by  te.id_entrega, cob.glosa1, par.codigo, pregas.id_ptogto,
                                                 pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                                 par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, tpro.id_beneficiario,
                                                 ban.banco, proc.nro_cuenta, tpla.monto, lib.banco, lib.cuenta, lib.libreta,ges.gestion, mul.codigo,pregas.id_catpry,
                                                 tpla.otros_descuentos, tpla.monto_retgar_mo, tpla.liquido_pagable, tpla.id_plan_pago, transa.factor_reversion,
                                                 top.nro_preventivo, tpla.descuento_ley loop


                        v_monto_total_prorra = v_registros.monto;
                        v_monto_partida = v_monto_total_prorra;

                        v_monto_total_auth = v_monto_total;

                        if v_registros.retenciones > 0 then


                            v_monto_total_prorra = v_monto_total_prorra * coalesce(v_registros.porc_monto_retgar, 0.93);
                            v_monto_total_prorra = v_monto_partida - v_monto_total_prorra;

                            --begin verificar redondeo
                            if round(v_monto_total_prorra,2) + v_monto_verficador <= v_registros.liquido_pagable then
                                v_monto_verficador = v_monto_verficador + round(v_monto_total_prorra,2);
                                v_monto_partida = round(v_monto_total_prorra,2);
                            else
                                v_monto_verficador = v_monto_verficador + trunc(v_monto_total_prorra,2);
                                v_monto_partida = trunc(v_monto_total_prorra,2);
                            end if;
                            --end

                            v_monto_total_auth = v_monto_total_auth - v_registros.retenciones;
                        end if;

                        if v_registros.descuento_inter_serv > 0 then
                            v_monto_partida = v_monto_partida - v_registros.descuento_inter_serv;
                            v_monto_total_auth = v_monto_total_auth - v_registros.descuento_inter_serv;
                        end if;

                        if v_registros.descuento_ley > 0 then
                            v_monto_partida = v_monto_partida - v_registros.descuento_ley;
                        end if;



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
                                usuario_apro,
                                multa,
                                retencion,
                                liquido_pagable,
                                sisin,
                                otfin,
                                usuario_firm,
                                cod_multa,
                                id_usuario_reg,
                                fecha_reg,
                                id_usuario_ai,
                                usuario_ai,
                                id_usuario_mod,
                                fecha_mod,
                                fecha_tipo_cambio,
                                nro_preventivo,
                                nro_deposito,
                                fecha_deposito,
                                monto_deposito,
                                total_deposito
                            ) values(
                                        'activo',
                                        v_id_sigep_cont_s,
                                        v_registros.gestion,
                                        v_registros.clase_gasto::int8,
                                        v_registros.moneda,
                                        -v_monto_total_auth,--v_registros.liquido_pagable --v_monto_total_auth,--v_datos_sigep.monto,
                                        v_registros.id_ptogto,
                                        -v_monto_partida,--v_monto_total_prorra, --v_registros.monto,
                                        '50',	--v_parametros.tipo_doc_rdo
                                        v_deposito.nro_deposito::integer,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        --upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
                                        v_registros.glosa,
                                        v_registros.id_beneficiario,
                                        v_registros.banco_benef,
                                        v_registros.cuenta_benef,
                                        v_registros.id_fuente,
                                        v_registros.id_organismo,
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        v_registros.libreta,
                                        -v_registros.liquido_pagable,
                                        v_aprobador,
                                        -v_registros.multas,
                                        -v_registros.retenciones,
                                        -v_registros.liquido_pagable,
                                        v_registros.sisin,
                                        '',
                                        v_firmador,
                                        v_registros.cod_multa,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_registros.nro_preventivo,
                                        v_deposito.nro_deposito,
                                        v_deposito.fecha_deposito,
                                        v_deposito.monto_deposito,
                                        v_deposito.monto
                                    );
                        END IF;

                    END LOOP;
                END IF;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*')
            into v_array_str;

            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


            -- Devuelve la respuesta
            return v_resp;


        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_REGU_CIP'
 	#DESCRIPCION:	carga datos del siguiente estado de Cbte Contabilidad para Regularizacion en el Sigep
 	#AUTOR:		rzabala
 	#FECHA:		16-05-2019 15:32:51
	***********************************/

    elseif(p_transaccion='SIGEP_REGU_CIP')then
        begin

            --Sentencia de la modificacion
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tint_comprobante
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;

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
                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;
                IF(v_record.codigo = 'verificado')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'aprobado')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;
            v_i = 1;


            FOR v_datos_sigep in SELECT  cob.nro_tramite,
                                         tcg.nombre,
                                         scg.clase_gasto,
                                         to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                         sum(tra.importe_gasto + tra.importe_reversion) as monto,
                                         cob.id_int_comprobante,
                                         cob.fecha fecha_tipo_cambio
                                 FROM conta.tint_comprobante cob
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                          INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                          INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tra.id_centro_costo
                                          INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                          inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                          inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                          inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
                                          inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                          inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                          inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                          inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                 WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by cob.nro_tramite, tcg.nombre, scg.clase_gasto, cob.id_int_comprobante loop


                --IF v_datos_sigep.monto != 0 THEN
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
                    localidad,
                    id_usuario_reg,
                    fecha_reg,
                    id_usuario_ai,
                    usuario_ai,
                    id_usuario_mod,
                    fecha_mod,
                    id_int_comprobante
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
                            v_parametros.localidad,
                            p_id_usuario,
                            now(),
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            null,
                            null,
                            v_datos_sigep.id_int_comprobante
                        )RETURNING id_sigep_adq into v_id_sigep_cont_s;

                v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;


                for v_registros in SELECT
                                       cob.id_int_comprobante,
                                       cob.nro_tramite,
                                       cob.glosa1,
                                       --cue.nro_cuenta,
                                       par.codigo,
                                       --cc.id_centro_costo,
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
                                       sum(transa.importe_gasto) + sum(transa.importe_reversion) as monto,
                                       ges.gestion
                                   FROM conta.tint_comprobante cob
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                            inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
                                            inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                            inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                            inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
                                            inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                            inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                            inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                            inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                            inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf /*AND par.id_partida = v_datos_sigep.id_partida*/

                                   group by cob.id_int_comprobante, cob.glosa1, /*cue.nro_cuenta,*/ par.codigo, /*cc.id_centro_costo,*/ pregas.id_ptogto,
                                            pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                            par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, ges.gestion loop

                    IF (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then
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
                            fecha_mod,
                            liquido_pagable,
                            fecha_tipo_cambio
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
                                    --upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
                                    upper(v_registros.glosa1),
                                    '83797',
                                    '',
                                    '',
                                    v_registros.id_fuente,
                                    v_registros.id_organismo,
                                    v_registros.banco,
                                    v_registros.cuenta,
                                    '',
                                    v_datos_sigep.monto,
                                    v_user,
                                    now(),
                                    v_parametros._id_usuario_ai,
                                    v_parametros._nombre_usuario_ai,
                                    null,
                                    null,
                                    v_datos_sigep.monto,
                                    v_datos_sigep.fecha_tipo_cambio
                                );

                    END IF;

                END LOOP;
                --END IF;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*') into v_array_str;


            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


            -- Devuelve la respuesta
            return v_resp;
        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_REGU_ENT_CIP'
 	#DESCRIPCION:	carga datos de un grupo de entrega de Contabilidad para Regularizacion en el Sigep
 	#AUTOR:		franklin.espinoza
 	#FECHA:		27-09-2020 12:00:00
	***********************************/

    elseif(p_transaccion='SIGEP_REGU_ENT_CIP')then
        begin

            --Sentencia de la modificacion
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tentrega
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;

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

                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;
                IF(v_record.codigo = 'verifificado')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'aprobado')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;
            v_i = 1;

            select tus.cuenta
            into v_aprobador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'verificado';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'aprobado';

            FOR v_datos_sigep in SELECT  tcg.nombre,
                                         scg.clase_gasto,
                                         to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                         sum(tra.importe_gasto + tra.importe_reversion) as monto,
                                         te.id_entrega,
                                         cob.fecha fecha_tipo_cambio
                                 FROM conta.tentrega te
                                          inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                          inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante and tra.importe_gasto != 0
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                          INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                          INNER JOIN pre.tpresupuesto tp ON tp.id_presupuesto = tra.id_centro_costo
                                          INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                          inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                          inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                          inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
                                          inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                          inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                          inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                          inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                 WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by tcg.nombre, scg.clase_gasto, te.id_entrega, fecha_tipo_cambio loop

                select cob.nro_tramite
                into v_nro_tramite
                from conta.tentrega te
                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                where te.id_entrega = v_datos_sigep.id_entrega
                limit 1;

                SELECT sum(tra.importe_haber)
                into v_retencion_header
                FROM conta.tentrega te
                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                         INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                         INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                WHERE te.id_proceso_wf = v_parametros.id_proceso_wf and tpar.codigo = '39150';

                /*SELECT count(te.id_entrega) ret_count, cob.id_depto
            into v_ret_count, v_id_depto
            FROM conta.tentrega te
             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
             inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
             inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_gasto != 0
             inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
             inner join pre.tpartida par on par.id_partida = transa.id_partida
             inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
             inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
             inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
             inner join pre.tclase_gasto cg ON cg.id_clase_gasto = tcgp.id_clase_gasto
             inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
             inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
             inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida and objgas.id_gestion = cp.id_gestion
             inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
             inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
             inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
             inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
             inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
             INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
             INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
            WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
            group by te.id_entrega,cob.id_depto;*/

                for v_record in SELECT count(te.id_entrega) ret_count, cob.id_depto
                                FROM conta.tentrega te
                                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                         inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_gasto != 0
                                         inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                         inner join pre.tpartida par on par.id_partida = transa.id_partida
                                         inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                         inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                         inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                         inner join pre.tclase_gasto cg ON cg.id_clase_gasto = tcgp.id_clase_gasto
                                         inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                         inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                         inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida and objgas.id_gestion = cp.id_gestion
                                         inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                         inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                         inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                         inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                         inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                         INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                         INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                group by te.id_entrega, par.id_partida, cob.id_depto loop

                    v_ret_count = v_ret_count + 1;
                    v_id_depto = v_record.id_depto;
                end loop;

                if v_id_depto in (50) and v_ret_count > 1 then

                    /*Mas de un programa*/
                    /*for v_validar_programa in SELECT count(te.id_entrega) ret_count, cob.id_depto
                                          FROM conta.tentrega te
                                           inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                           inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                           inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_gasto != 0
                                           inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                           inner join pre.tpartida par on par.id_partida = transa.id_partida
                                           inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                           inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                           inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                           inner join pre.tclase_gasto cg ON cg.id_clase_gasto = tcgp.id_clase_gasto
                                           inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                           inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                           inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida and objgas.id_gestion = cp.id_gestion
                                           inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                           inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                           inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                           inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                           inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                           INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                           INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                          WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                          group by te.id_entrega, cob.id_depto, cp.codigo_categoria loop
                	v_validar_contador = v_validar_contador + 1;
                end loop;*/

                    for v_validar_programa in SELECT cp.id_categoria_programatica, cp.codigo_categoria, cob.id_depto
                                              FROM conta.tentrega te
                                                       inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                       inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                                       inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_gasto != 0
                                                       inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                                       inner join pre.tpartida par on par.id_partida = transa.id_partida
                                                       inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                                       inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                                       inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                                       inner join pre.tclase_gasto cg ON cg.id_clase_gasto = tcgp.id_clase_gasto
                                                       inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                                       inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                                       inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida and objgas.id_gestion = cp.id_gestion
                                                       inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                                       inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                                       inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                                       inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                                       inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                                       INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                                       INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                              WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                              order by cp.id_categoria_programatica asc loop

                        if v_validar_programa.id_categoria_programatica != v_valor_programa and v_valor_programa != 0 then
                            v_validar_contador = v_validar_contador + 1;
                        end if;

                        v_valor_programa = v_validar_programa.id_categoria_programatica;
                    end loop;
                    --raise 'v_validar_contador: %',v_validar_contador;
                    if v_validar_contador >/*=*/1 then
                        v_retencion_value = v_retencion_header/v_validar_contador;
                    else
                        v_retencion_value = v_retencion_header/v_ret_count;
                    end if;
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
                    localidad,
                    id_usuario_reg,
                    fecha_reg,
                    id_usuario_ai,
                    usuario_ai,
                    id_usuario_mod,
                    fecha_mod,
                    id_int_comprobante
                ) values(
                            'activo',
                            v_nro_tramite,
                            'pre-registro',
                            v_parametros.momento,
                            '',
                            v_datos_sigep.nombre,
                            null,
                            null,
                            null,
                            v_parametros.localidad,
                            p_id_usuario,
                            now(),
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            null,
                            null,
                            v_datos_sigep.id_entrega
                        ) RETURNING id_sigep_adq into v_id_sigep_cont_s;

                v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;


                /*SELECT  count(te.id_entrega) total
            into v_cantidad_partida
            FROM conta.tentrega te
            inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
            inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
            INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante and tra.importe_gasto != 0
            INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
            INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
            INNER JOIN pre.tpresupuesto tp ON tp.id_presupuesto = tra.id_centro_costo
            INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
            inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
            inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
            inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
            inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
            inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
            inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
            inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
            WHERE te.id_proceso_wf = v_parametros.id_proceso_wf;*/

                for v_record in SELECT count(te.id_entrega) total
                                FROM conta.tentrega te
                                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                         INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante and tra.importe_gasto != 0
                                         INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                         INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                         INNER JOIN pre.tpresupuesto tp ON tp.id_presupuesto = tra.id_centro_costo
                                         INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                         inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                         inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                         inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
                                         inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                         inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                         inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                         inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                group by tpar.id_partida loop
                    v_cantidad_partida = v_cantidad_partida + 1;
                end loop;
                --raise 'v_cantidad_partida: %', v_cantidad_partida;

                for v_registros in SELECT te.id_entrega,

                                          te.glosa,
                                          par.codigo,
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
                                          sum(transa.importe_gasto) + sum(transa.importe_reversion) as monto,
                                          ges.gestion,
                                          cob.id_depto
                                   FROM conta.tentrega te
                                            inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                            inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_gasto != 0
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                            inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
                                            inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                            inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                            inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
                                            inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                            inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                            inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                            inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                            inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                   group by te.id_entrega, te.glosa, par.codigo, pregas.id_ptogto,
                                            pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                            par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, ges.gestion, cob.id_depto loop

                    v_contador_partida = v_contador_partida + 1;

                    SELECT count(tdcv.id_doc_compra_venta)
                    into v_cont_doc
                    FROM conta.tentrega te
                             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                             inner join conta.tint_comprobante tcom on tcom.id_int_comprobante = ted.id_int_comprobante
                             inner join conta.tdoc_compra_venta tdcv on tdcv.id_int_comprobante = tcom.id_int_comprobante
                    where  te.id_proceso_wf = v_parametros.id_proceso_wf and tdcv.id_plantilla = 1;


                    if v_cont_doc > 0 then

                        SELECT sum(tra.importe_gasto )
                        into v_monto_rciva
                        FROM conta.tentrega te
                                 inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                 inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                 INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                 INNER JOIN conta.tcuenta tcue on tcue.id_cuenta = tra.id_cuenta and tcue.nombre_cuenta = 'CREDITO FISCAL IVA BOLIVIA'
                        WHERE te.id_proceso_wf = v_parametros.id_proceso_wf;

                    end if;

                    SELECT tra.importe_haber
                    into v_retencion
                    FROM conta.tentrega te
                             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                             inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                             INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                             INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                    WHERE te.id_proceso_wf = v_parametros.id_proceso_wf and tpar.codigo = '39150' limit 1;



                    IF (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then

                        if v_registros.id_depto in (50) then

                            if v_ret_count > 1 then
                                v_retencion = v_retencion_value;
                            else
                                v_retencion = v_retencion;
                            end if;

                            v_diferencia_header = v_datos_sigep.monto - v_retencion_header;
                            v_diferencia_partida = v_registros.monto - v_retencion;
                            --raise 'v_contador_partida %, v_cantidad_partida %, v_retencion %', v_contador_partida,  v_cantidad_partida, v_retencion;
                            if v_contador_partida = v_cantidad_partida and v_retencion > 0 and v_registros.monto > v_retencion then

                                select sum(sig.monto_partida)
                                into v_total_partida
                                from sigep.tsigep_adq_det sig
                                where sig.id_sigep_adq = v_id_sigep_cont_s;

                                select sig.total_autorizado_mo
                                into v_total_autorizado
                                from sigep.tsigep_adq_det sig
                                where sig.id_sigep_adq = v_id_sigep_cont_s;

                                if v_total_autorizado > v_total_partida + v_diferencia_partida then
                                    v_diferencia_centavo = v_total_autorizado - (v_total_partida + v_diferencia_partida);
                                    v_diferencia_partida = v_diferencia_partida + v_diferencia_centavo;
                                elsif v_total_autorizado < v_total_partida + v_diferencia_partida then
                                    v_diferencia_centavo = (v_total_partida + v_diferencia_partida) - v_total_autorizado;
                                    v_diferencia_partida = v_diferencia_partida - v_diferencia_centavo;
                                end if;

                            end if;

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
                                fecha_mod,
                                liquido_pagable,
                                fecha_tipo_cambio,
                                usuario_apro,
                                usuario_firm
                            ) values(
                                        'activo',
                                        v_id_sigep_cont_s,
                                        v_registros.gestion,
                                        v_registros.clase_gasto::int8,
                                        v_registros.moneda,
                                        --case when v_flag_rciva then v_datos_sigep.monto + v_monto_rciva else v_datos_sigep.monto end,
                                        case when v_retencion > 0 and v_registros.monto > v_retencion then v_diferencia_header else v_datos_sigep.monto end,
                                        v_registros.id_ptogto,
                                        --case when v_flag_rciva then v_registros.monto + v_monto_rciva else v_registros.monto end,
                                        --case when v_registros.monto - v_retencion = 3359.61 then 3359.60 else v_registros.monto - v_retencion end,
                                        case when v_retencion > 0 and v_registros.monto > v_retencion then v_diferencia_partida else v_registros.monto end,
                                        '74',	--v_parametros.tipo_doc_rdo
                                        v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        --upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
                                        v_registros.glosa,--upper(v_registros.glosa),
                                        '83797',
                                        '',
                                        '',
                                        v_registros.id_fuente,
                                        v_registros.id_organismo,
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        '',
                                        --case when v_flag_rciva then v_datos_sigep.monto + v_monto_rciva else v_datos_sigep.monto end,
                                        case when v_retencion > 0 and v_registros.monto > v_retencion then v_diferencia_header else v_datos_sigep.monto end,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        --case when v_flag_rciva then v_datos_sigep.monto + v_monto_rciva else v_datos_sigep.monto end,
                                        case when v_retencion > 0 and v_registros.monto > v_retencion then v_diferencia_header else v_datos_sigep.monto end,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_aprobador,
                                        v_firmador
                                    );
                        else
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
                                fecha_mod,
                                liquido_pagable,
                                fecha_tipo_cambio,
                                usuario_apro,
                                usuario_firm
                            ) values(
                                        'activo',
                                        v_id_sigep_cont_s,
                                        v_registros.gestion,
                                        v_registros.clase_gasto::int8,
                                        v_registros.moneda,
                                        --case when v_flag_rciva then v_datos_sigep.monto + v_monto_rciva else v_datos_sigep.monto end,
                                        v_datos_sigep.monto,
                                        v_registros.id_ptogto,
                                        --case when v_flag_rciva then v_registros.monto + v_monto_rciva else v_registros.monto end,
                                        v_registros.monto,
                                        '74',	--v_parametros.tipo_doc_rdo
                                        v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        --upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
                                        v_registros.glosa,--upper(v_registros.glosa),
                                        '83797',
                                        '',
                                        '',
                                        v_registros.id_fuente,
                                        v_registros.id_organismo,
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        '',
                                        --case when v_flag_rciva then v_datos_sigep.monto + v_monto_rciva else v_datos_sigep.monto end,
                                        v_datos_sigep.monto,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        --case when v_flag_rciva then v_datos_sigep.monto + v_monto_rciva else v_datos_sigep.monto end,
                                        v_datos_sigep.monto,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_aprobador,
                                        v_firmador
                                    );
                        end if;

                    END IF;

                    v_flag_rciva = false;

                END LOOP;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*')
            into v_array_str;


            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


            -- Devuelve la respuesta
            return v_resp;
        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_REG_ENTREV_CIP'
 	#DESCRIPCION:	carga datos de un grupo de entrega de Contabilidad para Regularizacion en el Sigep
 	#AUTOR:		franklin.espinoza
 	#FECHA:		27-09-2020 12:00:00
	***********************************/

    elseif(p_transaccion='SIGEP_REG_ENTREV_CIP')then
        begin

            --Sentencia de la modificacion
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tentrega
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;

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

                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;
                IF(v_record.codigo = 'verifificado')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'aprobado')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;
            v_i = 1;

            select tus.cuenta
            into v_aprobador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'verificado';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'aprobado';

            FOR v_datos_sigep in SELECT  tcg.nombre,
                                         scg.clase_gasto,
                                         to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                         -(sum(tra.importe_recurso + tra.importe_reversion)) as monto,
                                         te.id_entrega,
                                         cob.fecha fecha_tipo_cambio
                                 FROM conta.tentrega te
                                          inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                          inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante and tra.importe_recurso != 0
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                          INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                          INNER JOIN pre.tpresupuesto tp ON tp.id_presupuesto = tra.id_centro_costo
                                          INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                          inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                          inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                          inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
                                          inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                          inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                          inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                          inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                 WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by tcg.nombre, scg.clase_gasto, te.id_entrega, fecha_tipo_cambio loop

                select tsa.nro_preventivo , tsa.nro_comprometido, tsa.nro_devengado
                into v_nro_preventivo, v_nro_comprometido, v_nro_devengado
                from conta.tentrega ten
                         inner join conta.tentrega_det ted on ted.id_entrega = ten.id_entrega
                         inner join sigep.tsigep_adq tsa on tsa.id_int_comprobante = ted.id_entrega
                where   ted.id_int_comprobante = (select tic.id_int_comprobante_fks[1]
                                                  from conta.tentrega te
                                                           inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                           inner join conta.tint_comprobante tic on tic.id_int_comprobante = ted.id_int_comprobante
                                                  where te.id_proceso_wf =  v_parametros.id_proceso_wf limit 1) and tsa.nro_preventivo is not null and
                    tsa.nro_comprometido is not null and tsa.nro_devengado is not null;

                select cob.nro_tramite
                into v_nro_tramite
                from conta.tentrega te
                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                where te.id_entrega = v_datos_sigep.id_entrega
                limit 1;


                for v_record in SELECT count(te.id_entrega) ret_count, cob.id_depto
                                FROM conta.tentrega te
                                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                         inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_gasto != 0
                                         inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                         inner join pre.tpartida par on par.id_partida = transa.id_partida
                                         inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                         inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                         inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                         inner join pre.tclase_gasto cg ON cg.id_clase_gasto = tcgp.id_clase_gasto
                                         inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                         inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                         inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida and objgas.id_gestion = cp.id_gestion
                                         inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                         inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                         inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                         inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                         inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                         INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                         INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                group by te.id_entrega, par.id_partida, cob.id_depto loop

                    v_ret_count = v_ret_count + 1;
                    v_id_depto = v_record.id_depto;
                end loop;

                if v_id_depto in (50) and v_ret_count > 1 then

                    SELECT sum(tra.importe_debe)
                    into v_retencion_header
                    FROM conta.tentrega te
                             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                             inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                             INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                             INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                    WHERE te.id_proceso_wf = v_parametros.id_proceso_wf and tpar.codigo = '39150';

                    for v_validar_programa in SELECT cp.id_categoria_programatica, cp.codigo_categoria, cob.id_depto
                                              FROM conta.tentrega te
                                                       inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                       inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                                       inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_gasto != 0
                                                       inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                                       inner join pre.tpartida par on par.id_partida = transa.id_partida
                                                       inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                                       inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                                       inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                                       inner join pre.tclase_gasto cg ON cg.id_clase_gasto = tcgp.id_clase_gasto
                                                       inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                                       inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                                       inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida and objgas.id_gestion = cp.id_gestion
                                                       inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                                       inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                                       inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                                       inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                                       inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                                       INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                                       INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                              WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                              order by cp.id_categoria_programatica asc loop

                        if v_validar_programa.id_categoria_programatica != v_valor_programa and v_valor_programa != 0 then
                            v_validar_contador = v_validar_contador + 1;
                        end if;

                        v_valor_programa = v_validar_programa.id_categoria_programatica;
                    end loop;

                    if v_validar_contador > 1 then
                        v_retencion_value = v_retencion_header/v_validar_contador;
                    else
                        v_retencion_value = v_retencion_header/v_ret_count;
                    end if;

                    for v_record in SELECT count(te.id_entrega) total
                                    FROM conta.tentrega te
                                             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                             inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                             INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante and tra.importe_gasto != 0
                                             INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                             INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                             INNER JOIN pre.tpresupuesto tp ON tp.id_presupuesto = tra.id_centro_costo
                                             INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                             inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                             inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                             inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
                                             inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                             inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                             inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                             inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                    WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                    group by tpar.id_partida loop
                        v_cantidad_partida = v_cantidad_partida + 1;
                    end loop;

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
                    localidad,
                    id_usuario_reg,
                    fecha_reg,
                    id_usuario_ai,
                    usuario_ai,
                    id_usuario_mod,
                    fecha_mod,
                    id_int_comprobante
                ) values(
                            'activo',
                            v_nro_tramite,
                            'pre-registro',
                            v_parametros.momento,
                            '',
                            v_datos_sigep.nombre,
                            v_nro_preventivo,
                            v_nro_comprometido,
                            v_nro_devengado,
                            v_parametros.localidad,
                            p_id_usuario,
                            now(),
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            null,
                            null,
                            v_datos_sigep.id_entrega
                        )RETURNING id_sigep_adq into v_id_sigep_cont_s;

                v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;

                for v_registros in SELECT te.id_entrega,

                                          te.glosa,
                                          --cue.nro_cuenta,
                                          par.codigo,
                                          --cc.id_centro_costo,
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
                                          -(sum(transa.importe_recurso) + sum(transa.importe_reversion)) as monto,
                                          ges.gestion,
                                          cob.id_depto
                                   FROM conta.tentrega te
                                            inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                            inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_recurso != 0
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                            inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
                                            inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                            inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                            inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
                                            inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                            inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                            inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                            inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                            inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                   group by te.id_entrega, te.glosa,/*cue.nro_cuenta,*/ par.codigo, /*cc.id_centro_costo,*/ pregas.id_ptogto,
                                            pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                            par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, ges.gestion, cob.id_depto loop


                    IF (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then
                        if v_registros.id_depto in (50) then

                            v_contador_partida = v_contador_partida + 1;

                            SELECT count(tdcv.id_doc_compra_venta)
                            into v_cont_doc
                            FROM conta.tentrega te
                                     inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                     inner join conta.tint_comprobante tcom on tcom.id_int_comprobante = ted.id_int_comprobante
                                     inner join conta.tdoc_compra_venta tdcv on tdcv.id_int_comprobante = tcom.id_int_comprobante
                            where  te.id_proceso_wf = v_parametros.id_proceso_wf and tdcv.id_plantilla = 1;


                            if v_cont_doc > 0 then

                                SELECT sum(tra.importe_gasto )
                                into v_monto_rciva
                                FROM conta.tentrega te
                                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                         INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                         INNER JOIN conta.tcuenta tcue on tcue.id_cuenta = tra.id_cuenta and tcue.nombre_cuenta = 'CREDITO FISCAL IVA BOLIVIA'
                                WHERE te.id_proceso_wf = v_parametros.id_proceso_wf;

                            end if;

                            SELECT tra.importe_debe
                            into v_retencion
                            FROM conta.tentrega te
                                     inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                     inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                     INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                     INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                            WHERE te.id_proceso_wf = v_parametros.id_proceso_wf and tpar.codigo = '39150' limit 1;

                            if v_ret_count > 1 then
                                v_retencion = v_retencion_value;
                            else
                                v_retencion = v_retencion;
                            end if;

                            v_diferencia_header = v_datos_sigep.monto + v_retencion_header;
                            v_diferencia_partida = v_registros.monto + v_retencion;
                            --raise 'v_contador_partida %, v_cantidad_partida %, v_retencion %', v_contador_partida,  v_cantidad_partida, v_retencion;
                            if v_contador_partida = v_cantidad_partida and v_retencion > 0 and v_registros.monto > v_retencion then

                                select sum(sig.monto_partida)
                                into v_total_partida
                                from sigep.tsigep_adq_det sig
                                where sig.id_sigep_adq = v_id_sigep_cont_s;

                                select sig.total_autorizado_mo
                                into v_total_autorizado
                                from sigep.tsigep_adq_det sig
                                where sig.id_sigep_adq = v_id_sigep_cont_s;

                                if v_total_autorizado > v_total_partida + v_diferencia_partida then
                                    v_diferencia_centavo = v_total_autorizado + (v_total_partida + v_diferencia_partida);
                                    v_diferencia_partida = v_diferencia_partida - v_diferencia_centavo;
                                elsif v_total_autorizado < v_total_partida - v_diferencia_partida then
                                    v_diferencia_centavo = (v_total_partida - v_diferencia_partida) + v_total_autorizado;
                                    v_diferencia_partida = v_diferencia_partida + v_diferencia_centavo;
                                end if;

                            end if;

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
                                fecha_mod,
                                liquido_pagable,
                                fecha_tipo_cambio,
                                usuario_apro,
                                usuario_firm
                            ) values(
                                        'activo',
                                        v_id_sigep_cont_s,
                                        v_registros.gestion,
                                        v_registros.clase_gasto::int8,
                                        v_registros.moneda,
                                        case when v_retencion > 0 /*and v_registros.monto > v_retencion*/ then v_diferencia_header else v_datos_sigep.monto end,--v_datos_sigep.monto,
                                        v_registros.id_ptogto,
                                        case when v_retencion > 0 /*and v_registros.monto > v_retencion*/ then v_diferencia_partida else v_registros.monto end,--v_registros.monto,
                                        '74',	--v_parametros.tipo_doc_rdo
                                        v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        v_registros.glosa,--upper(v_registros.glosa),
                                        '83797',
                                        '',
                                        '',
                                        v_registros.id_fuente,
                                        v_registros.id_organismo,
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        '',
                                        case when v_retencion > 0 /*and v_registros.monto > v_retencion*/ then v_diferencia_header else v_datos_sigep.monto end,--v_datos_sigep.monto,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        case when v_retencion > 0 /*and v_registros.monto > v_retencion*/ then v_diferencia_header else v_datos_sigep.monto end,--v_datos_sigep.monto,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_aprobador,
                                        v_firmador
                                    );
                        else
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
                                fecha_mod,
                                liquido_pagable,
                                fecha_tipo_cambio,
                                usuario_apro,
                                usuario_firm
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
                                        v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        --upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
                                        v_registros.glosa,--upper(v_registros.glosa),
                                        '83797',
                                        '',
                                        '',
                                        v_registros.id_fuente,
                                        v_registros.id_organismo,
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        '',
                                        v_datos_sigep.monto,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        v_datos_sigep.monto,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_aprobador,
                                        v_firmador
                                    );
                        end if;

                    END IF;

                END LOOP;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*')
            into v_array_str;


            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


            -- Devuelve la respuesta
            return v_resp;
        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_REG_ENTREV_SIP'
 	#DESCRIPCION:	carga datos de un grupo de Cbtes de Contabilidad para Regularizacion en el Sigep sin imputacion
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-11-2020 15:32:51
	***********************************/

    elseif(p_transaccion='SIGEP_REG_ENTREV_SIP')then
        begin

            --Sentencia de la modificacion
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tentrega
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;

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

                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;
                IF(v_record.codigo = 'verifificado')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'aprobado')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;
            v_i = 1;

            select tus.cuenta
            into v_aprobador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'verificado';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'aprobado';

            FOR v_datos_sigep in SELECT
                                     tcg.nombre,
                                     scg.clase_gasto,
                                     to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                     -(sum(transa.importe_recurso + transa.importe_reversion)) as monto,
                                     te.id_entrega,
                                     cob.fecha fecha_tipo_cambio
                                 FROM conta.tentrega te
                                          inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                          inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                          inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                          inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                          inner join pre.tpartida par on par.id_partida = transa.id_partida
                                          inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                          inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                          inner join pre.tclase_gasto_cuenta tcgc on tcgc.id_cuenta = cue.id_cuenta

                                          inner join sigep.tcuenta_contable tcc on tcc.id_cuenta = tcgc.id_cuenta

                                          inner join pre.tclase_gasto tcg ON tcg.id_clase_gasto= tcgc.id_clase_gasto
                                          inner join sigep.tclase_gasto_sip scg ON scg.id_clase_gasto = tcg.id_clase_gasto

                                          inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                          inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                          INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                          INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                 WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by tcg.nombre, scg.clase_gasto, te.id_entrega, fecha_tipo_cambio loop

                select tsa.nro_preventivo , tsa.nro_comprometido, tsa.nro_devengado
                into v_nro_preventivo, v_nro_comprometido, v_nro_devengado
                from conta.tentrega ten
                         inner join conta.tentrega_det ted on ted.id_entrega = ten.id_entrega
                         inner join sigep.tsigep_adq tsa on tsa.id_int_comprobante = ted.id_entrega
                where   ted.id_int_comprobante = (select tic.id_int_comprobante_fks[1]
                                                  from conta.tentrega te
                                                           inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                           inner join conta.tint_comprobante tic on tic.id_int_comprobante = ted.id_int_comprobante
                                                  where te.id_proceso_wf =  v_parametros.id_proceso_wf limit 1) and tsa.nro_preventivo is not null and
                    tsa.nro_comprometido is not null and tsa.nro_devengado is not null;

                select cob.nro_tramite
                into v_nro_tramite
                from conta.tentrega te
                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                where te.id_entrega = v_datos_sigep.id_entrega
                limit 1;

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
                    localidad,
                    id_usuario_reg,
                    fecha_reg,
                    id_usuario_ai,
                    usuario_ai,
                    id_usuario_mod,
                    fecha_mod,
                    id_int_comprobante
                ) values(
                            'activo',
                            v_nro_tramite,
                            'pre-registro',
                            v_parametros.momento,
                            '',
                            v_datos_sigep.nombre,
                            v_nro_preventivo,
                            v_nro_comprometido,
                            v_nro_devengado,
                            v_parametros.localidad,
                            p_id_usuario,
                            now(),
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            null,
                            null,
                            v_datos_sigep.id_entrega
                        )RETURNING id_sigep_adq into v_id_sigep_cont_s;

                v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;


                for v_registros in SELECT te.id_entrega,
                                          te.glosa,
                                          --cue.nro_cuenta,
                                          par.codigo,
                                          --cc.id_centro_costo,
                                          scba.banco,
                                          scba.cuenta,
                                          to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                          smo.moneda,
                                          cp.id_categoria_programatica,
                                          cp.codigo_categoria,
                                          par.id_partida,
                                          scg.clase_gasto,
                                          scg.desc_clase_gasto,
                                          -(sum(transa.importe_recurso) + sum(transa.importe_reversion)) as monto,
                                          ges.gestion,
                                          cg.id_clase_gasto,
                                          tcc.cuenta_contable
                                   FROM conta.tentrega te
                                            inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                            inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                            inner join pre.tclase_gasto_cuenta tcgc on tcgc.id_cuenta = cue.id_cuenta

                                            inner join sigep.tcuenta_contable tcc on tcc.id_cuenta = tcgc.id_cuenta

                                            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgc.id_clase_gasto
                                            inner join sigep.tclase_gasto_sip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                            inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                            inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                   group by  te.id_entrega, cob.glosa1,/*cue.nro_cuenta,*/ par.codigo, /*cc.id_centro_costo,*/
                                             smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria, par.id_partida,
                                             scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, ges.gestion, cg.id_clase_gasto,
                                             tcc.cuenta_contable loop

                    IF (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then
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
                            fecha_mod,
                            liquido_pagable,
                            fecha_tipo_cambio,
                            cuenta_contable,
                            usuario_apro,
                            usuario_firm
                        ) values(
                                    'activo',
                                    v_id_sigep_cont_s,
                                    v_registros.gestion,
                                    v_registros.clase_gasto::int8,
                                    v_registros.moneda,
                                    v_datos_sigep.monto,
                                    null,--v_registros.id_ptogto
                                    v_registros.monto,
                                    '74',	--v_parametros.tipo_doc_rdo
                                    v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                    '1',	--v_parametros.sec_doc_rdo,
                                    v_registros.fecha, --fecha_elaboracion
                                    v_registros.glosa,--upper(v_registros.glosa1),
                                    '83797',
                                    '',
                                    '',
                                    null,--v_registros.id_fuente
                                    null,--v_registros.id_organismo
                                    v_registros.banco,
                                    v_registros.cuenta,
                                    '',
                                    v_datos_sigep.monto,
                                    v_user,
                                    now(),
                                    v_parametros._id_usuario_ai,
                                    v_parametros._nombre_usuario_ai,
                                    null,
                                    null,
                                    v_datos_sigep.monto,
                                    v_datos_sigep.fecha_tipo_cambio,
                                    v_registros.cuenta_contable,
                                    v_aprobador,
                                    v_firmador
                                );

                    END IF;

                END LOOP;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*')
            into v_array_str;


            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


            -- Devuelve la respuesta
            return v_resp;
        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_REGU_ENT_SIP'
 	#DESCRIPCION:	carga datos de un grupo de Cbtes de Contabilidad para Regularizacion en el Sigep
 	#AUTOR:		franklin.espinoza
 	#FECHA:		27-09-2020 15:32:51
	***********************************/

    elseif(p_transaccion='SIGEP_REGU_ENT_SIP')then
        begin

            --Sentencia de la modificacion
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tentrega
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;

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

                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;
                IF(v_record.codigo = 'verifificado')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'aprobado')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;
            v_i = 1;

            select tus.cuenta
            into v_aprobador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'verificado';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'aprobado';

            FOR v_datos_sigep in SELECT
                                     tcg.nombre,
                                     scg.clase_gasto,
                                     to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                     sum(transa.importe_gasto + transa.importe_reversion) as monto,
                                     te.id_entrega,
                                     cob.fecha fecha_tipo_cambio
                                 FROM conta.tentrega te
                                          inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                          inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                          inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                          inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                          inner join pre.tpartida par on par.id_partida = transa.id_partida
                                          inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                          inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                          inner join pre.tclase_gasto_cuenta tcgc on tcgc.id_cuenta = cue.id_cuenta

                                          inner join sigep.tcuenta_contable tcc on tcc.id_cuenta = tcgc.id_cuenta

                                          inner join pre.tclase_gasto tcg ON tcg.id_clase_gasto= tcgc.id_clase_gasto
                                          inner join sigep.tclase_gasto_sip scg ON scg.id_clase_gasto = tcg.id_clase_gasto

                                          inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                          inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                          INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                          INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                 WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by tcg.nombre, scg.clase_gasto, te.id_entrega, fecha_tipo_cambio loop

                select cob.nro_tramite
                into v_nro_tramite
                from conta.tentrega te
                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                where te.id_entrega = v_datos_sigep.id_entrega
                limit 1;

                SELECT sum(tra.importe_haber)
                into v_retencion_header
                FROM conta.tentrega te
                         inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                         inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                         INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                         INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                WHERE te.id_proceso_wf = v_parametros.id_proceso_wf and tpar.codigo = '39150';

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
                    localidad,
                    id_usuario_reg,
                    fecha_reg,
                    id_usuario_ai,
                    usuario_ai,
                    id_usuario_mod,
                    fecha_mod,
                    id_int_comprobante
                ) values(
                            'activo',
                            v_nro_tramite,
                            'pre-registro',
                            v_parametros.momento,
                            '',
                            v_datos_sigep.nombre,
                            null,
                            null,
                            null,
                            v_parametros.localidad,
                            p_id_usuario,
                            now(),
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            null,
                            null,
                            v_datos_sigep.id_entrega
                        )RETURNING id_sigep_adq into v_id_sigep_cont_s;

                v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;


                for v_registros in SELECT te.id_entrega,
                                          te.glosa,
                                          --cue.nro_cuenta,
                                          par.codigo,
                                          --cc.id_centro_costo,
                                          scba.banco,
                                          scba.cuenta,
                                          to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                          smo.moneda,
                                          cp.id_categoria_programatica,
                                          cp.codigo_categoria,
                                          par.id_partida,
                                          scg.clase_gasto,
                                          scg.desc_clase_gasto,
                                          sum(transa.importe_gasto + transa.importe_reversion) as monto,
                                          ges.gestion,
                                          cg.id_clase_gasto,
                                          tcc.cuenta_contable,
                                          cob.id_depto
                                   FROM conta.tentrega te
                                            inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                            inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                            inner join pre.tclase_gasto_cuenta tcgc on tcgc.id_cuenta = cue.id_cuenta

                                            inner join sigep.tcuenta_contable tcc on tcc.id_cuenta = tcgc.id_cuenta

                                            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgc.id_clase_gasto
                                            inner join sigep.tclase_gasto_sip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                            inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                            inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                   group by  te.id_entrega, cob.glosa1,/*cue.nro_cuenta,*/ par.codigo, /*cc.id_centro_costo,*/
                                             smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria, par.id_partida,
                                             scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, ges.gestion, cg.id_clase_gasto,
                                             tcc.cuenta_contable, cob.id_depto
                                   having sum( transa.importe_gasto + transa.importe_reversion ) > 0 loop


                    SELECT tra.importe_haber
                    into v_retencion
                    FROM conta.tentrega te
                             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                             inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                             INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                             INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                    WHERE te.id_proceso_wf = v_parametros.id_proceso_wf and tpar.codigo = '39150';

                    IF (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then

                        if v_registros.id_depto in (50) and v_retencion > 0 then

                            v_diferencia_header = v_datos_sigep.monto - v_retencion_header;
                            v_diferencia_partida = v_registros.monto - v_retencion;

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
                                fecha_mod,
                                liquido_pagable,
                                fecha_tipo_cambio,
                                cuenta_contable,
                                usuario_apro,
                                usuario_firm
                            ) values(
                                        'activo',
                                        v_id_sigep_cont_s,
                                        v_registros.gestion,
                                        v_registros.clase_gasto::int8,
                                        v_registros.moneda,
                                        --v_datos_sigep.monto,
                                        case when v_retencion > 0 and v_registros.monto > v_retencion then v_diferencia_header else v_datos_sigep.monto end,
                                        null,--v_registros.id_ptogto
                                        --v_registros.monto,
                                        case when v_retencion > 0 and v_registros.monto > v_retencion then v_diferencia_partida else v_registros.monto end,
                                        '74',	--v_parametros.tipo_doc_rdo
                                        v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        v_registros.glosa,--upper(v_registros.glosa1),
                                        '83797',
                                        '',
                                        '',
                                        null,--v_registros.id_fuente
                                        null,--v_registros.id_organismo
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        '',
                                        --v_datos_sigep.monto,
                                        case when v_retencion > 0 and v_registros.monto > v_retencion then v_diferencia_header else v_datos_sigep.monto end,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        v_datos_sigep.monto,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_registros.cuenta_contable,
                                        v_aprobador,
                                        v_firmador
                                    );
                        else

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
                                fecha_mod,
                                liquido_pagable,
                                fecha_tipo_cambio,
                                cuenta_contable,
                                usuario_apro,
                                usuario_firm
                            ) values(
                                        'activo',
                                        v_id_sigep_cont_s,
                                        v_registros.gestion,
                                        v_registros.clase_gasto::int8,
                                        v_registros.moneda,
                                        v_datos_sigep.monto,
                                        null,--v_registros.id_ptogto
                                        v_registros.monto,
                                        '74',	--v_parametros.tipo_doc_rdo
                                        v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        v_registros.glosa,--upper(v_registros.glosa1),
                                        '83797',
                                        '',
                                        '',
                                        null,--v_registros.id_fuente
                                        null,--v_registros.id_organismo
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        '',
                                        v_datos_sigep.monto,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        v_datos_sigep.monto,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_registros.cuenta_contable,
                                        v_aprobador,
                                        v_firmador
                                    );

                        end if;

                    END IF;

                END LOOP;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*')
            into v_array_str;


            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);


            -- Devuelve la respuesta
            return v_resp;
        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_REGU_SIP'
 	#DESCRIPCION:	Carga datos del siguiente estado de Cbte Contabilidad para envio a Sigep
 	#AUTOR:		franklin.espinoza
 	#FECHA:		09-09-2020 15:32:51
	***********************************/

    elseif(p_transaccion='SIGEP_REGU_SIP')then
        begin
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tint_comprobante
            where id_proceso_wf = v_parametros.id_proceso_wf;

            v_i = 1;

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
                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;
                IF(v_record.codigo = 'vbconta')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'vbfin')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;

            v_i = 1;


            FOR v_datos_sigep in SELECT   cob.nro_tramite,
                                          tcg.nombre,
                                          scg.clase_gasto,
                                          to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                          sum(transa.importe_gasto + transa.importe_reversion) as monto,
                                          cob.id_int_comprobante,
                                          cob.fecha fecha_tipo_cambio
                                 FROM conta.tint_comprobante cob
                                          inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                          inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                          inner join pre.tpartida par on par.id_partida = transa.id_partida
                                          inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                          inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                          inner join pre.tclase_gasto_cuenta tcgc on tcgc.id_cuenta = cue.id_cuenta

                                          inner join sigep.tcuenta_contable tcc on tcc.id_cuenta = tcgc.id_cuenta

                                          inner join pre.tclase_gasto tcg ON tcg.id_clase_gasto= tcgc.id_clase_gasto
                                          inner join sigep.tclase_gasto_sip scg ON scg.id_clase_gasto = tcg.id_clase_gasto

                                          inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                          inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                          INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                          INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                 WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by cob.nro_tramite, tcg.nombre, scg.clase_gasto, cob.id_int_comprobante loop



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
                    localidad,
                    id_usuario_reg,
                    fecha_reg,
                    id_usuario_ai,
                    usuario_ai,
                    id_usuario_mod,
                    fecha_mod,
                    id_int_comprobante
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
                            v_parametros.localidad,
                            p_id_usuario,
                            now(),
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            null,
                            null,
                            v_datos_sigep.id_int_comprobante
                        )RETURNING id_sigep_adq into v_id_sigep_cont_s;

                v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;


                for v_registros in SELECT cob.id_int_comprobante,
                                          cob.nro_tramite,
                                          cob.glosa1,
                                          --cue.nro_cuenta,
                                          par.codigo,
                                          --cc.id_centro_costo,
                                          scba.banco,
                                          scba.cuenta,
                                          to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                          smo.moneda,
                                          cp.id_categoria_programatica,
                                          cp.codigo_categoria,
                                          par.id_partida,
                                          scg.clase_gasto,
                                          scg.desc_clase_gasto,
                                          sum(transa.importe_gasto + transa.importe_reversion) as monto,
                                          ges.gestion,
                                          cg.id_clase_gasto,
                                          tcc.cuenta_contable
                                   FROM conta.tint_comprobante cob
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                            inner join pre.tclase_gasto_cuenta tcgc on tcgc.id_cuenta = cue.id_cuenta

                                            inner join sigep.tcuenta_contable tcc on tcc.id_cuenta = tcgc.id_cuenta

                                            inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgc.id_clase_gasto
                                            inner join sigep.tclase_gasto_sip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                            inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                            inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria
                                            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf
                                   group by  cob.id_int_comprobante, cob.glosa1,/*cue.nro_cuenta,*/ par.codigo, /*cc.id_centro_costo,*/
                                             smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria, par.id_partida,
                                             scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, ges.gestion, cg.id_clase_gasto,
                                             tcc.cuenta_contable loop

                    IF (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then
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
                            fecha_mod,
                            liquido_pagable,
                            fecha_tipo_cambio,
                            cuenta_contable
                        ) values(
                                    'activo',
                                    v_id_sigep_cont_s,
                                    v_registros.gestion,
                                    v_registros.clase_gasto::int8,
                                    v_registros.moneda,
                                    v_datos_sigep.monto,
                                    null,--v_registros.id_ptogto
                                    v_registros.monto,
                                    '74',	--v_parametros.tipo_doc_rdo
                                    v_registros.id_int_comprobante,	--v_parametros.nro_doc_rdo,
                                    '1',	--v_parametros.sec_doc_rdo,
                                    v_registros.fecha, --fecha_elaboracion
                                    upper(v_registros.glosa1),
                                    '83797',
                                    '',
                                    '',
                                    null,--v_registros.id_fuente
                                    null,--v_registros.id_organismo
                                    v_registros.banco,
                                    v_registros.cuenta,
                                    '',
                                    v_datos_sigep.monto,
                                    v_user,
                                    now(),
                                    v_parametros._id_usuario_ai,
                                    v_parametros._nombre_usuario_ai,
                                    null,
                                    null,
                                    v_datos_sigep.monto,
                                    v_datos_sigep.fecha_tipo_cambio,
                                    v_registros.cuenta_contable
                                );

                    END IF;

                END LOOP;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*')
            into v_array_str;


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
            select id_estado_wf, id_usuario_reg
            into v_record_sol
            from conta.tint_comprobante
            where id_int_comprobante = v_parametros.id_int_comprobante;
            v_i = 1;
            --v_array_str = '';
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
                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;--(select us.cuenta
                --from  segu.vusuario us
                --where us.id_usuario = v_record_sol.id_usuario_reg);
                END IF;
                IF(v_record.codigo = 'vbconta')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;
                IF(v_record.codigo = 'vbfin')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;

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
                                v_user,
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
                                    usuario_apro,
                                    multa,
                                    retencion,
                                    liquido_pagable,
                                    cuenta_contable,
                                    sisin,
                                    otfin,
                                    usuario_firm,
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
                                            v_aprobador,
                                            '0',
                                            '0',
                                            v_registros.liquido_pagable,
                                            v_registros.cuenta_contable,
                                            '',
                                            '',
                                            v_firmador,
                                            v_user,
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

        /*********************************
 	#TRANSACCION:  'DOC_C31_REF_VIA'
 	#DESCRIPCION:	C31 Normales para envio a Sigep CIP para Refrigerio y Viaticos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		14-01-2022 15:32:51
	***********************************/

    elseif(p_transaccion='DOC_C31_REF_VIA')then
        begin

            select id_estado_wf, id_usuario_reg into v_record_sol
            from conta.tentrega
            where id_proceso_wf = v_parametros.id_proceso_wf;
            v_i = 1;

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

                IF(v_record.codigo = 'borrador')THEN
                    v_user = v_record_sol.id_usuario_reg;
                END IF;

                IF(v_record.codigo = 'vbconta')THEN
                    v_aprobador = (select us.cuenta
                                   from orga.vfuncionario fun
                                            inner join segu.vusuario us on us.id_persona = fun.id_persona
                                   where fun.id_funcionario = v_record.id_funcionario);
                END IF;

                IF(v_record.codigo = 'vbfin')THEN
                    v_firmador = (select us.cuenta
                                  from orga.vfuncionario fun
                                           inner join segu.vusuario us on us.id_persona = fun.id_persona
                                  where fun.id_funcionario = v_record.id_funcionario);
                END IF;
            END LOOP;

            select tus.cuenta
            into v_aprobador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'verificado';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CONEN' and tes.codigo = 'aprobado';


            FOR v_datos_sigep in SELECT   tcg.nombre,
                                          scg.clase_gasto,
                                          to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                          sum(tra.importe_gasto + tra.importe_reversion) as monto,
                                          te.id_entrega,
                                          cob.fecha fecha_tipo_cambio,
                                          cob.localidad
                                 FROM conta.tentrega te
                                          inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                          inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                          INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                          INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tra.id_centro_costo
                                          INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog
                                          inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                          inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                          inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica
                                          inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                          left join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                          left join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                          inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente
                                 WHERE te.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by tcg.nombre, scg.clase_gasto, te.id_entrega, fecha_tipo_cambio, cob.localidad loop

                IF v_datos_sigep.monto != 0 THEN
                    select cob.nro_tramite, ted.id_int_comprobante, cob.id_proceso_wf
                    into v_nro_tramite, v_id_int_comprobante, v_id_proceso_wf
                    from conta.tentrega te
                             inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                             inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                    where te.id_entrega = v_datos_sigep.id_entrega
                    limit 1;

                    select count(tdcv.id_doc_compra_venta)
                    into v_cont_doc
                    from conta.tint_comprobante tcom
                             inner join conta.tdoc_compra_venta tdcv on tdcv.id_int_comprobante = tcom.id_int_comprobante
                    where tcom.id_proceso_wf = v_id_proceso_wf and tdcv.id_plantilla = 1;

                    /*select sum(case when ts.importe_recurso !=0 then ts.importe_recurso else ts.importe_gasto_mt end )
                    into v_diferencia_redondeo
                    from conta.tint_transaccion ts
                    where ts.id_int_comprobante = v_id_int_comprobante and ts.id_detalle_plantilla_comprobante is null;

                    if v_diferencia_redondeo > 0 then
                        v_monto_total = v_datos_sigep.monto-v_diferencia_redondeo;
                    else*/
                    v_monto_total = v_datos_sigep.monto;
                    --end if;

                    if v_cont_doc > 0 then
                        select sum(tp.monto_ejecutar_mo) - tpp.descuento_ley
                        into v_monto_total
                        from conta.tint_comprobante tc
                                 inner join tes.tplan_pago tpp on tpp.id_int_comprobante = tc.id_int_comprobante
                                 inner join tes.tprorrateo tp on tp.id_plan_pago = tpp.id_plan_pago
                        where tc.id_int_comprobante = v_id_int_comprobante--v_datos_sigep.id_entrega
                        group by tpp.descuento_ley;
                    end if;
                    v_contador = 1;
                    /******************************************************* lista beneficiario *******************************************************/
                    for v_beneficiario in select distinct tod.id_funcionario, prov.id_beneficiario beneficiario, ban.banco, cta.nro_cuenta cuenta_ben, sum (tod.monto_pago_mo) importe_ben
                                          from conta.tentrega_det ted
                                                   inner join tes.tplan_pago pp on pp.id_int_comprobante = ted.id_int_comprobante
                                                   inner join tes.tobligacion_det tod on tod.id_obligacion_pago = pp.id_obligacion_pago
                                                   inner join orga.tfuncionario tf on tf.id_funcionario = tod.id_funcionario
                                              --inner join orga.tfuncionario_cuenta_bancaria cb on cb.id_funcionario = tf.id_funcionario
                                                   inner join param.tproveedor prov on prov.id_persona = tf.id_persona
                                                   inner join  param.tproveedor_cta_bancaria cta on cta.id_proveedor = prov.id_proveedor
                                                   inner join sigep.tbanco ban on ban.id_institucion = cta.id_banco_beneficiario
                                          where ted.id_entrega = v_datos_sigep.id_entrega and cta.estado_reg = 'activo'
                                          group by tod.id_funcionario, prov.id_beneficiario, cta.nro_cuenta, ban.banco loop
                        raise notice 'v_beneficiario: %.- %', v_contador, v_beneficiario;
                        v_lista_beneficiario = v_lista_beneficiario|| ('{"beneficiario":'||trim(v_beneficiario.beneficiario)||', "banco":'||v_beneficiario.banco||', "cuenta":"'||trim(v_beneficiario.cuenta_ben)||'", "montoMo":'||v_beneficiario.importe_ben||'}')::jsonb;
                        v_contador = v_contador + 1;
                    end loop;
                    /******************************************************* lista beneficiario *******************************************************/
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
                        localidad,
                        id_usuario_reg,
                        fecha_reg,
                        id_usuario_ai,
                        usuario_ai,
                        id_usuario_mod,
                        fecha_mod,
                        id_int_comprobante,
                        lista_beneficiario
                    ) values(
                                'activo',
                                v_nro_tramite,
                                'pre-registro',
                                v_parametros.momento,
                                '',
                                v_datos_sigep.nombre,
                                null,
                                null,
                                null,
                                v_datos_sigep.localidad,
                                p_id_usuario,
                                now(),
                                v_parametros._id_usuario_ai,
                                v_parametros._nombre_usuario_ai,
                                null,
                                null,
                                v_datos_sigep.id_entrega,
                                v_lista_beneficiario
                            )RETURNING id_sigep_adq into v_id_sigep_cont_s;

                    v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                    v_array_str:=v_id_sigep_cont_s;
                    v_i = v_i+1;

                    for v_registros in SELECT  te.id_entrega,
                                               te.glosa,
                                               par.codigo,
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
                                               --sum(transa.importe_gasto) /*+ sum(transa.importe_reversion)*/ as monto,
                                               sum(tpror.monto_ejecutar_mo) as monto,
                                               tpla.liquido_pagable,
                                               tpro.id_beneficiario,
                                               ban.banco as banco_benef,
                                               trim(proc.nro_cuenta) as cuenta_benef,
                                               tpla.liquido_pagable as monto_benef,
                                               tpla.otros_descuentos as multas,
                                               tpla.monto_retgar_mo as retenciones,
                                               lib.banco,
                                               lib.cuenta,
                                               lib.libreta,
                                               ges.gestion,
                                               tpla.id_plan_pago,
                                               transa.factor_reversion,
                                               tpla.descuento_inter_serv,
                                               tpla.descuento_ley,
                                               mul.codigo as cod_multa,
                                               pregas.id_catpry as sisin,
                                               top.nro_preventivo
                                       FROM conta.tentrega te
                                                inner join conta.tentrega_det ted on ted.id_entrega = te.id_entrega
                                                inner join conta.tint_comprobante cob on cob.id_int_comprobante = ted.id_int_comprobante
                                           --inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante
                                                inner join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante
                                                inner join tes.tprorrateo tpror on tpror.id_plan_pago = tpla.id_plan_pago
                                                inner join conta.tint_transaccion transa on transa.id_int_transaccion = tpror.id_int_transaccion

                                                inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                                inner join pre.tpartida par on par.id_partida = transa.id_partida
                                                inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                                inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                                inner join pre.tclase_gasto_partida tcgp ON tcgp.id_partida = par.id_partida
                                                inner join pre.tclase_gasto cg ON cg.id_clase_gasto= tcgp.id_clase_gasto
                                                inner join sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = cg.id_clase_gasto
                                                inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = cp.id_categoria_programatica
                                                inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = par.id_partida  and objgas.id_gestion = cp.id_gestion
                                                inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                                inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                                inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = cp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente

                                           --inner join tes.tplan_pago tpla on tpla.id_int_comprobante = cob.id_int_comprobante
                                                inner join tes.tobligacion_pago top on top.id_obligacion_pago = tpla.id_obligacion_pago

                                                LEFT JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                                left JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                                inner join param.tproveedor_cta_bancaria proc on proc.id_proveedor_cta_bancaria = tpla.id_proveedor_cta_bancaria
                                                inner join param.tproveedor tpro on tpro.id_proveedor = proc.id_proveedor
                                                inner join sigep.tbanco ban on ban.id_institucion = proc.id_banco_beneficiario
                                                inner join sigep.tlibreta lib on lib.id_cuenta_bancaria = tpla.id_cuenta_bancaria
                                                left join sigep.tmulta mul on mul.id_multa = tpla.id_multa
                                                inner JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                                inner JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                       WHERE te.id_proceso_wf = v_parametros.id_proceso_wf

                                       group by  te.id_entrega, cob.glosa1, par.codigo, pregas.id_ptogto,
                                                 pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                                 par.id_partida, scg.clase_gasto, scg.desc_clase_gasto, scba.banco, scba.cuenta, tpro.id_beneficiario,
                                                 ban.banco, proc.nro_cuenta, tpla.monto, lib.banco, lib.cuenta, lib.libreta,ges.gestion, mul.codigo,pregas.id_catpry,
                                                 tpla.otros_descuentos, tpla.monto_retgar_mo, tpla.liquido_pagable, tpla.id_plan_pago, transa.factor_reversion,
                                                 top.nro_preventivo, tpla.descuento_ley loop


                        v_monto_total_prorra = v_registros.monto;
                        v_monto_partida = v_monto_total_prorra;


                        v_monto_total_auth = v_monto_total;
                        if v_registros.retenciones > 0 then
                            v_monto_total_prorra = v_monto_total_prorra * 0.93;

                            --begin verificar redondeo
                            if round(v_monto_total_prorra,2) + v_monto_verficador <= v_registros.liquido_pagable then
                                v_monto_verficador = v_monto_verficador + round(v_monto_total_prorra,2);
                                v_monto_partida = round(v_monto_total_prorra,2);
                            else
                                v_monto_verficador = v_monto_verficador + trunc(v_monto_total_prorra,2);
                                v_monto_partida = trunc(v_monto_total_prorra,2);
                            end if;
                            --end

                            v_monto_total_auth = v_monto_total_auth - v_registros.retenciones;
                        end if;

                        if v_registros.descuento_inter_serv > 0 then
                            --v_monto_total_prorra = v_monto_total_prorra - v_registros.descuento_inter_serv;
                            v_monto_partida = v_monto_partida - v_registros.descuento_inter_serv;
                            v_monto_total_auth = v_monto_total_auth - v_registros.descuento_inter_serv;
                        end if;

                        if v_registros.descuento_ley > 0 then
                            --v_monto_total_prorra = v_monto_total_prorra - v_registros.descuento_ley;
                            v_monto_partida = v_monto_partida - v_registros.descuento_ley;
                        end if;


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
                                usuario_apro,
                                multa,
                                retencion,
                                liquido_pagable,
                                sisin,
                                otfin,
                                usuario_firm,
                                cod_multa,
                                id_usuario_reg,
                                fecha_reg,
                                id_usuario_ai,
                                usuario_ai,
                                id_usuario_mod,
                                fecha_mod,
                                fecha_tipo_cambio,
                                nro_preventivo
                            ) values(
                                        'activo',
                                        v_id_sigep_cont_s,
                                        v_registros.gestion,
                                        v_registros.clase_gasto::int8,
                                        v_registros.moneda,
                                        v_monto_total_auth,--v_registros.liquido_pagable --v_monto_total_auth,--v_datos_sigep.monto,
                                        v_registros.id_ptogto,
                                        v_monto_partida,--v_monto_total_prorra, --v_registros.monto,
                                        '4',	--v_parametros.tipo_doc_rdo
                                        v_registros.id_entrega,	--v_parametros.nro_doc_rdo,
                                        '1',	--v_parametros.sec_doc_rdo,
                                        v_registros.fecha, --fecha_elaboracion
                                        --upper(concat('Para registrar el ', v_registros.glosa1, ',cbte ', v_registros.nro_tramite,', de acuerdo a documentación adjunta.')),
                                        v_registros.glosa,
                                        v_registros.id_beneficiario,
                                        v_registros.banco_benef,
                                        v_registros.cuenta_benef,
                                        v_registros.id_fuente,
                                        v_registros.id_organismo,
                                        v_registros.banco,
                                        v_registros.cuenta,
                                        v_registros.libreta,
                                        v_registros.liquido_pagable,
                                        v_aprobador,
                                        v_registros.multas,
                                        v_registros.retenciones,
                                        v_registros.liquido_pagable,
                                        v_registros.sisin,
                                        '',
                                        v_firmador,
                                        v_registros.cod_multa,
                                        v_user,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        v_datos_sigep.fecha_tipo_cambio,
                                        v_registros.nro_preventivo
                                    );
                        END IF;

                    END LOOP;
                END IF;
            END LOOP;

            select array_to_string(v_id_sigep_regu_s,',','*')
            into v_array_str;

            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consulta datos Sigep se almaceno con éxito (id_sigep_cont'||v_id_sigep_cont_s||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep',v_array_str::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_parametros.momento::varchar);

            -- Devuelve la respuesta
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
    COST 100;

ALTER FUNCTION sigep.ft_sigep_adq_det_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;