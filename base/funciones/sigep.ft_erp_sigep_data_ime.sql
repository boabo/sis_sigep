CREATE OR REPLACE FUNCTION sigep.ft_erp_sigep_data_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_erp_sigep_data_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.ft_erp_sigep_data_ime'
 AUTOR: 		(franklin.espinoza)
 FECHA:	        16-12-2021 09:30:47
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				25-03-2019 15:50:47								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.ft_erp_sigep_data_ime'
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
    v_beneficiario          record;
    v_lista_beneficiario    jsonb = '[]'::jsonb;
BEGIN

    v_nombre_funcion = 'sigep.ft_erp_sigep_data_ime';
    v_parametros = pxp.f_get_record(p_tabla);


    /**************************************************************** Documentos C21 ****************************************************************/
    /*********************************
 	#TRANSACCION:  'SIGEP_CON_FLUJO_C21'
 	#DESCRIPCION:	carga datos de un comprobante de Contabilidad para la generacion del C21 correspondiente.
 	#AUTOR:		franklin.espinoza
 	#FECHA:		15-09-2021 12:00:00
	***********************************/

    if ( p_transaccion='SIGEP_CON_FLUJO_C21' )then
        begin

            select id_estado_wf, id_usuario_reg into v_record_sol
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
            where ttp.codigo = 'CBTE' and tes.codigo = 'verificado' and tft.estado_reg = 'activo';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CBTE' and tes.codigo = 'aprobado' and tft.estado_reg = 'activo';


            FOR v_datos_sigep in SELECT
                                     to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                     sum(tra.importe_recurso + tra.importe_reversion) as monto,
                                     cob.id_int_comprobante,
                                     cob.fecha fecha_tipo_cambio
                                 FROM conta.tint_comprobante cob
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante and tra.importe_recurso != 0
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                     /*INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpar.id_partida
                                     INNER JOIN pre.tpresupuesto tp ON tp.id_presupuesto = tra.id_centro_costo
                                     INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog*/
                                          inner join sigep.trubro rub on rub.id_partida = tpar.id_partida
                                     /*inner JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto
                                     inner JOIN sigep.tclase_gasto_cip scg ON scg.id_clase_gasto = tcg.id_clase_gasto
                                     inner JOIN sigep.tproyecto_actividad proyact on proyact.id_categoria_programatica = vcp.id_categoria_programatica --and proyact.id_catprg = pregas.id_catprg
                                     inner JOIN sigep.tobjeto_gasto objgas on objgas.id_partida = tpar.id_partida  and objgas.id_gestion = vcp.id_gestion
                                     inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = vcp.id_cp_fuente_fin
                                     inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = vcp.id_unidad_ejecutora
                                     inner JOIN sigep.tpresupuesto_gasto pregas on proyact.id_catprg = pregas.id_catprg and pregas.id_gestion = vcp.id_gestion and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue and pregas.id_fuente = tff.id_fuente*/
                                 WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by /*tcg.nombre, scg.clase_gasto,*/ cob.id_int_comprobante, fecha_tipo_cambio loop

                select cob.nro_tramite
                into v_nro_tramite
                from conta.tint_comprobante cob
                where cob.id_int_comprobante = v_datos_sigep.id_int_comprobante
                limit 1;

                insert into sigep.tsigep_adq(
                    estado_reg,
                    num_tramite,
                    estado,
                    momento,
                    ultimo_mensaje,
                    --clase_gasto,
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
                            --v_datos_sigep.nombre,
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
                        ) RETURNING id_sigep_adq into v_id_sigep_cont_s;

                v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;


                for v_registros in SELECT
                                       cob.id_int_comprobante,
                                       cob.glosa1 glosa,
                                       par.codigo,
                                       scba.banco,
                                       scba.cuenta,
                                       to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                       pregas.id_ptorec,
                                       pregas.id_fuente,
                                       pregas.id_organismo,
                                       smo.moneda,
                                       cp.id_categoria_programatica,
                                       cp.codigo_categoria,
                                       par.id_partida,
                                       sum(transa.importe_recurso) + sum(transa.importe_reversion) as monto,
                                       ges.gestion,
                                       pregas.id_rubro,
                                       pregas.id_ent_otorgante
                                   FROM conta.tint_comprobante cob
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_recurso != 0
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog

                                            inner join sigep.trubro rub on rub.id_partida = par.id_partida

                                            inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                            inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                            inner JOIN sigep.tpresupuesto_recurso pregas on pregas.id_rubro = rub.id_rubro and pregas.id_gestion = cp.id_gestion /*and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue*/ and pregas.id_fuente = tff.id_fuente
                                            inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                            inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf
                                   group by cob.id_int_comprobante, cob.glosa1, par.codigo, pregas.id_ptorec,
                                            pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                            par.id_partida, /*scg.clase_gasto, scg.desc_clase_gasto,*/ scba.banco, scba.cuenta, ges.gestion,
                                            pregas.id_rubro, pregas.id_ent_otorgante loop

                    SELECT count(tdcv.id_doc_compra_venta)
                    into v_cont_doc
                    FROM conta.tint_comprobante tcom
                             inner join conta.tdoc_compra_venta tdcv on tdcv.id_int_comprobante = tcom.id_int_comprobante
                    where  tcom.id_proceso_wf = v_parametros.id_proceso_wf and tdcv.id_plantilla = 1;


                    if v_cont_doc > 0 then

                        SELECT sum(tra.importe_gasto )
                        into v_monto_rciva
                        FROM conta.tint_comprobante cob
                                 INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante
                                 INNER JOIN conta.tcuenta tcue on tcue.id_cuenta = tra.id_cuenta and tcue.nombre_cuenta = 'CREDITO FISCAL IVA BOLIVIA'
                        WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf;

                    end if;

                    --IF (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then
                    insert into sigep.tsigep_adq_det(
                        estado_reg,
                        id_sigep_adq,
                        gestion,
                        moneda,
                        total_autorizado_mo,
                        id_ptorec,
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
                        usuario_firm,
                        id_rubro,
                        id_ent_otorgante
                    ) values(
                                'activo',
                                v_id_sigep_cont_s,
                                v_registros.gestion,
                                v_registros.moneda,
                                v_datos_sigep.monto,
                                v_registros.id_ptorec,
                                v_registros.monto,
                                '4',
                                v_registros.id_int_comprobante,
                                '1',
                                v_registros.fecha,
                                v_registros.glosa,
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
                                v_firmador,
                                v_registros.id_rubro,
                                v_registros.id_ent_otorgante
                            );

                    --END IF;
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
         #TRANSACCION:  'SIGEP_REV_CMF_C21'
         #DESCRIPCION:	carga datos de un comprobante de Contabilidad para la generacion del C21 correspondiente.
         #AUTOR:		franklin.espinoza
         #FECHA:		15-09-2021 12:00:00
        ***********************************/

    elsif ( p_transaccion='SIGEP_REV_CMF_C21' )then
        begin

            select id_estado_wf, id_usuario_reg into v_record_sol
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
            where ttp.codigo = 'CBTE' and tes.codigo = 'verificado' and tft.estado_reg = 'activo';

            select tus.cuenta
            into v_firmador
            from wf.ttipo_proceso ttp
                     inner join wf.ttipo_estado tes on tes.id_tipo_proceso =  ttp.id_tipo_proceso
                     inner join wf.tfuncionario_tipo_estado tft on tft.id_tipo_estado =  tes.id_tipo_estado
                     inner join orga.vfuncionario vf on vf.id_funcionario = tft.id_funcionario
                     inner join segu.tusuario tus on tus.id_persona = vf.id_persona
            where ttp.codigo = 'CBTE' and tes.codigo = 'aprobado' and tft.estado_reg = 'activo';


            FOR v_datos_sigep in SELECT to_char(CURRENT_DATE,'DD/MM/YYYY')::date as fecha,
                                        -(sum(tra.importe_gasto + tra.importe_reversion)) as monto,
                                        cob.id_int_comprobante,
                                        cob.fecha fecha_tipo_cambio
                                 FROM conta.tint_comprobante cob
                                          INNER JOIN conta.tint_transaccion tra on tra.id_int_comprobante = cob.id_int_comprobante and tra.importe_gasto != 0
                                          INNER JOIN pre.tpartida tpar ON tpar.id_partida = tra.id_partida
                                          inner join sigep.trubro rub on rub.id_partida = tpar.id_partida
                                 WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf
                                 group by cob.id_int_comprobante, fecha_tipo_cambio loop

                select tsa.nro_preventivo , tsa.nro_comprometido, tsa.nro_devengado
                into v_nro_preventivo, v_nro_comprometido, v_nro_devengado
                from conta.tint_comprobante ten
                         inner join sigep.tsigep_adq tsa on tsa.id_int_comprobante = ten.id_int_comprobante
                where   ten.id_int_comprobante = (select tic.id_int_comprobante_fks[1]
                                                  from  conta.tint_comprobante tic
                                                  where tic.id_proceso_wf =  v_parametros.id_proceso_wf limit 1) and tsa.nro_preventivo is not null and
                    tsa.nro_comprometido is not null and tsa.nro_devengado is not null and tsa.tipo_documento = 'c21';

                select cob.nro_tramite
                into v_nro_tramite
                from conta.tint_comprobante cob
                where cob.id_int_comprobante = v_datos_sigep.id_int_comprobante
                limit 1;

                insert into sigep.tsigep_adq(
                    estado_reg,
                    num_tramite,
                    estado,
                    momento,
                    ultimo_mensaje,
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
                    tipo_documento
                ) values(
                            'activo',
                            v_nro_tramite,
                            'pre-registro',
                            v_parametros.momento,
                            '',
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
                            v_datos_sigep.id_int_comprobante,
                            'c21'
                        ) RETURNING id_sigep_adq into v_id_sigep_cont_s;

                v_id_sigep_regu_s[v_i]:=v_id_sigep_cont_s ;
                v_array_str:=v_id_sigep_cont_s;
                v_i = v_i+1;


                for v_registros in SELECT
                                       cob.id_int_comprobante,
                                       cob.glosa1 glosa,
                                       par.codigo,
                                       scba.banco,
                                       scba.cuenta,
                                       coalesce(cob.fecha, to_char(CURRENT_DATE,'DD/MM/YYYY')::date) as fecha,
                                       pregas.id_ptorec,
                                       pregas.id_fuente,
                                       pregas.id_organismo,
                                       smo.moneda,
                                       cp.id_categoria_programatica,
                                       cp.codigo_categoria,
                                       par.id_partida,
                                       -(sum(transa.importe_gasto) + sum(transa.importe_reversion)) as monto,
                                       ges.gestion,
                                       pregas.id_rubro,
                                       pregas.id_ent_otorgante
                                   FROM conta.tint_comprobante cob
                                            inner join conta.tint_transaccion transa on transa.id_int_comprobante = cob.id_int_comprobante and transa.importe_gasto != 0
                                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                            inner join pre.tpartida par on par.id_partida = transa.id_partida
                                            inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                                            inner join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                                            inner join sigep.trubro rub on rub.id_partida = par.id_partida
                                            inner join sigep.tfuente_financiamiento tff on tff.id_cp_fuente_fin = cp.id_cp_fuente_fin
                                            inner join sigep.tunidad_ejecutora ue on ue.id_unidad_ejecutora = cp.id_unidad_ejecutora
                                            inner JOIN sigep.tpresupuesto_recurso pregas on pregas.id_rubro = rub.id_rubro and pregas.id_gestion = cp.id_gestion /*and pregas.id_objeto = objgas.id_objeto and pregas.id_ue = ue.id_ue*/ and pregas.id_fuente = tff.id_fuente
                                            inner JOIN tes.tcuenta_bancaria cba ON cba.id_cuenta_bancaria = cob.id_cuenta_bancaria
                                            inner JOIN sigep.tcuenta_bancaria scba ON scba.id_cuenta_bancaria = cba.id_cuenta_bancaria

                                            INNER JOIN sigep.tmoneda smo ON smo.id_moneda = cob.id_moneda
                                            INNER JOIN param.tgestion ges ON ges.id_gestion = cp.id_gestion
                                   WHERE cob.id_proceso_wf = v_parametros.id_proceso_wf
                                   group by cob.id_int_comprobante, cob.glosa1, par.codigo, pregas.id_ptorec,
                                            pregas.id_fuente, pregas.id_organismo, smo.moneda, cp.id_categoria_programatica, cp.codigo_categoria,
                                            par.id_partida, /*scg.clase_gasto, scg.desc_clase_gasto,*/ scba.banco, scba.cuenta, ges.gestion,
                                            pregas.id_rubro, pregas.id_ent_otorgante loop


                    --IF (v_datos_sigep.clase_gasto = v_registros.clase_gasto )then
                    insert into sigep.tsigep_adq_det(
                        estado_reg,
                        id_sigep_adq,
                        gestion,
                        moneda,
                        total_autorizado_mo,
                        id_ptorec,
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
                        usuario_firm,
                        id_rubro,
                        id_ent_otorgante
                    ) values(
                                'activo',
                                v_id_sigep_cont_s,
                                v_registros.gestion,
                                v_registros.moneda,
                                v_datos_sigep.monto,
                                v_registros.id_ptorec,
                                v_registros.monto,
                                '4',
                                v_registros.id_int_comprobante,
                                '1',
                                v_registros.fecha,
                                v_registros.glosa,
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
                                v_firmador,
                                v_registros.id_rubro,
                                v_registros.id_ent_otorgante
                            );

                    --END IF;
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

        /**************************************************************** Documentos C21 ****************************************************************/
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

ALTER FUNCTION sigep.ft_erp_sigep_data_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;