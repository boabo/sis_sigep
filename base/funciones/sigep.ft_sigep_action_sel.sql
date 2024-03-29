CREATE OR REPLACE FUNCTION sigep.ft_sigep_action_sel (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_sigep_action_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tsigep_adq'
 AUTOR: 		 (rzabala)
 FECHA:	        15-03-2019 21:10:26
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-03-2019 21:10:26								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tsigep_adq'
 #
 ***************************************************************************/

DECLARE

    v_consulta    		varchar;
    v_query    		 	varchar;
    v_parametros  		record;
    v_nombre_funcion   	text;
    v_resp				varchar;

BEGIN

    v_nombre_funcion = 'sigep.ft_sigep_action_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'SIGEP_SADQ_A_SEL'
     #DESCRIPCION:	Consulta de datos
     #AUTOR:		rzabala
     #FECHA:		15-03-2019 21:10:26
    ***********************************/

    if(p_transaccion='SIGEP_SADQ_A_SEL')then

        begin
            /*if v_parametros.sigep_adq = 'vbsigepconta' then
                UPDATE sigep.tsigep_adq
                SET momento = 'COMPROMETIDO-DEVENGADO'
                WHERE nro_preventivo is not null
            END IF;*/

            --Sentencia de la consulta
            v_consulta:='select
						sadq.id_sigep_adq,
						sadq.estado_reg,
						sadq.num_tramite,
						sadq.estado,
						sadq.momento,
						sadq.ultimo_mensaje,
						sadq.clase_gasto,
                        sadq.id_service_request,
                        sadq.nro_preventivo,
                        sadq.nro_comprometido,
                        sadq.nro_devengado,
						sadq.id_usuario_reg,
						sadq.fecha_reg,
						sadq.id_usuario_ai,
						sadq.usuario_ai,
						sadq.id_usuario_mod,
						sadq.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from sigep.tsigep_adq sadq
						inner join segu.tusuario usu1 on usu1.id_usuario = sadq.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = sadq.id_usuario_mod
				        where  ';

            --de ser necesario adicionar--inner join adq.tsolicitud sol on sol.num_tramite = sadq.num_tramite

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by id_sigep_adq ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice 'v_consulta: %', v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
         #TRANSACCION:  'SIGEP_SADQ_A_CONT'
         #DESCRIPCION:	Conteo de registros
         #AUTOR:		rzabala
         #FECHA:		15-03-2019 21:10:26
        ***********************************/

    elsif(p_transaccion='SIGEP_SADQ_A_CONT')then

        begin

            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_sigep_adq)
					    from sigep.tsigep_adq sadq
					    inner join segu.tusuario usu1 on usu1.id_usuario = sadq.id_usuario_reg
                        --inner join adq.tsolicitud sol on sol.num_tramite = sadq.num_tramite
						left join segu.tusuario usu2 on usu2.id_usuario = sadq.id_usuario_mod
					    where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            raise notice 'v_consulta: %', v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
         #TRANSACCION:  'SIGEP_CONS_A'
         #DESCRIPCION:	Consulta para datos de envio al Sigep
         #AUTOR:		rzabala
         #FECHA:		04-06-2019 16:10:26
        ***********************************/

    elsif(p_transaccion='SIGEP_CONS_A')then

        begin
            --Sentencia de la consulta
            --raise exception 'checkpoint CONSULTA BENEFICIARIO SIGEP: %', v_parametros.id_sigep_adq;

            v_consulta:='SELECT
            		  sdet.id_sigep_adq,
                      sdet.gestion,
                      sdet.clase_gasto_cip,
                      sdet.moneda,
                      sdet.total_autorizado_mo,
                      sdet.id_ptogto,
                      sdet.monto_partida,
                      sdet.nro_doc_rdo,
                      sdet.sec_doc_rdo,
                      sdet.tipo_doc_rdo,
                      sdet.fecha_elaboracion,
                      sdet.justificacion,
                      sdet.id_fuente,
                      sdet.id_organismo,
                      usu1.cuenta,
                      sdet.beneficiario,
                      sdet.banco_benef,
                      sdet.cuenta_benef,
                      sdet.banco_origen,
                      sdet.cta_origen,
                      sdet.libreta_origen,
                      sdet.usuario_apro,
                      sig.clase_gasto,
                      sig.momento,
                      sig.nro_preventivo,
                      sig.nro_comprometido,
        			  sig.nro_devengado,
                      sdet.monto_benef,
                      sdet.liquido_pagable,
                      sdet.multa as multa_mo,
                      sdet.retencion as retencion_mo,
                      sdet.cuenta_contable,
                      sdet.sisin,
                      sdet.otfin,
                      sdet.usuario_firm,
                      sdet.cod_multa,
                      sdet.cod_retencion,
                      sdet.total_retencion,
                      sdet.mes_rdo,
                      sdet.tipo_rdo,
                      sdet.tipo_contrato,
                      sdet.fecha_tipo_cambio,
                      sdet.nro_preventivo as preventivo_sigep,

                      sdet.nro_deposito,
                      sdet.fecha_deposito,
                      sdet.monto_deposito,
                      sdet.total_deposito,

                      sig.lista_beneficiario beneficiarios

              FROM sigep.tsigep_adq_det sdet
              inner join segu.tusuario usu1 on usu1.id_usuario = sdet.id_usuario_reg
              left join segu.tusuario usu2 on usu2.id_usuario = sdet.id_usuario_mod
              inner join sigep.tsigep_adq sig on sig.id_sigep_adq = sdet.id_sigep_adq
              WHERE sdet.id_sigep_adq = '||v_parametros.id_sigep_adq;

            --Definicion de la respuesta
            v_consulta:=v_consulta||'ORDER BY sdet.id_sigep_adq';
            --v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --raise notice 'consulta: %', v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;
        /*********************************
    #TRANSACCION:  'SIGEP_A_DEL'
    #DESCRIPCION:	Consulta para datos de envio al Sigep
    #AUTOR:		rzabala
    #FECHA:		04-06-2019 16:10:26
   ***********************************/

    elsif(p_transaccion='SIGEP_A_DEL')then

        begin
            --Sentencia de la consulta
            --raise exception 'checkpoint CONSULTA DESV/ELIMN SIGEP: %', v_parametros.id_int_comprobante;

            v_consulta:='SELECT  	sig.id_service_request,
									sig.nro_preventivo,
        							sig.nro_comprometido,
        							sig.nro_devengado,
        							sdet.gestion
							FROM sigep.tsigep_adq sig
      							inner join segu.tusuario usu1 on usu1.id_usuario = sig.id_usuario_reg
      							left join segu.tusuario usu2 on usu2.id_usuario = sig.id_usuario_mod
      							inner join sigep.tsigep_adq_det sdet on sig.id_sigep_adq = sdet.id_sigep_adq
    						WHERE sig.estado_reg = ''activo''
    							and (sig.nro_preventivo, sig.nro_comprometido, sig.nro_devengado) is not null
    							and sdet.nro_doc_rdo = '||v_parametros.id_int_comprobante;

            --Definicion de la respuesta
            v_consulta:=v_consulta||'group by sig.id_service_request, sig.nro_preventivo, sig.nro_comprometido, sig.nro_devengado, sig.fecha_reg, sdet.gestion';
            --v_consulta:=v_consulta||'ORDER BY sdet.id_sigep_adq';
            --raise notice 'consulta: %', v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
 	#TRANSACCION:  'SIGEP_REPR_A_SEL'
 	#DESCRIPCION:	Listar Datos para el Reporte
 	#AUTOR:		rzabala
 	#FECHA:		05-06-2019 20:34:32
	***********************************/

    elsif(p_transaccion='SIGEP_REPR_A_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='select
            					sdet.id_sigep_adq
        					FROM sigep.tsigep_adq_det sdet
            				 inner join segu.tusuario usu1 on usu1.id_usuario = sdet.id_usuario_reg
              				 left join segu.tusuario usu2 on usu2.id_usuario = sdet.id_usuario_mod
              				 inner join sigep.tsigep_adq sig on sig.id_sigep_adq = sdet.id_sigep_adq
              				WHERE sdet.id_sigep_adq = '||v_parametros.id_sigep_adq;

            --Definicion de la respuesta
            v_consulta:=v_consulta||'ORDER BY sdet.id_sigep_adq';
            raise notice 'consulta: %', v_consulta;
            --v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
         #TRANSACCION:  'C21_GET_PARAMS'
         #DESCRIPCION:	Consulta para datos de envio al Sigep
         #AUTOR:		franklin.espinoza
         #FECHA:		04-01-2022 10:10:26
        ***********************************/

    elsif(p_transaccion='C21_GET_PARAMS')then

        begin
            --Sentencia de la consulta

            v_consulta:='SELECT
            		  sdet.id_sigep_adq,
                      sdet.gestion,
                      sdet.clase_gasto_cip,
                      sdet.moneda,
                      sdet.total_autorizado_mo,
                      sdet.id_ptorec,
                      sdet.monto_partida,
                      sdet.nro_doc_rdo,
                      sdet.sec_doc_rdo,
                      sdet.tipo_doc_rdo,
                      sdet.fecha_elaboracion,
                      sdet.justificacion,
                      sdet.id_fuente,
                      sdet.id_organismo,
                      usu1.cuenta,
                      sdet.beneficiario,
                      sdet.banco_benef,
                      sdet.cuenta_benef,
                      sdet.banco_origen,
                      sdet.cta_origen,
                      sdet.libreta_origen,
                      sdet.usuario_apro,
                      sig.clase_gasto,
                      sig.momento,
                      sig.nro_preventivo,
                      sig.nro_comprometido,
        			  sig.nro_devengado,
                      sdet.monto_benef,
                      sdet.liquido_pagable,
                      sdet.multa as multa_mo,
                      sdet.retencion as retencion_mo,
                      sdet.cuenta_contable,
                      sdet.sisin,
                      sdet.otfin,
                      sdet.usuario_firm,
                      sdet.cod_multa,
                      sdet.cod_retencion,
                      sdet.total_retencion,
                      sdet.mes_rdo,
                      sdet.tipo_rdo,
                      sdet.tipo_contrato,
                      sdet.fecha_tipo_cambio,
                      sdet.nro_preventivo as preventivo_sigep,
                      sdet.id_rubro,
                      sdet.id_ent_otorgante
              FROM sigep.tsigep_adq_det sdet
              inner join segu.tusuario usu1 on usu1.id_usuario = sdet.id_usuario_reg
              left join segu.tusuario usu2 on usu2.id_usuario = sdet.id_usuario_mod
              inner join sigep.tsigep_adq sig on sig.id_sigep_adq = sdet.id_sigep_adq
              WHERE sdet.id_sigep_adq = '||v_parametros.id_sigep_adq;

            --Definicion de la respuesta
            v_consulta:=v_consulta||'ORDER BY sdet.id_sigep_adq';
            --v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --raise notice 'consulta: %', v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;

    else

        raise exception 'Transaccion inexistente';

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

ALTER FUNCTION sigep.ft_sigep_action_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;