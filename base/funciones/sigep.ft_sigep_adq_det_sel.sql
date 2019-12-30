CREATE OR REPLACE FUNCTION sigep.ft_sigep_adq_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_sigep_adq_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tsigep_adq_det'
 AUTOR: 		 (rzabala)
 FECHA:	        25-03-2019 15:50:47
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				25-03-2019 15:50:47								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tsigep_adq_det'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'sigep.ft_sigep_adq_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_SAD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rzabala
 	#FECHA:		25-03-2019 15:50:47
	***********************************/

	if(p_transaccion='SIGEP_SAD_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						sad.id_sigep_adq_det,
                        sad.id_sigep_adq,
						sad.estado_reg,
						sad.gestion,
						sigad.clase_gasto as clase_gasto_cip,
						mo.codigo as moneda,
						sad.total_autorizado_mo,
						sad.id_ptogto,
						sad.monto_partida,
						doc.desc_documento as tipo_doc_rdo,
						sad.nro_doc_rdo,
						sad.sec_doc_rdo,
						sad.fecha_elaboracion,
						sad.justificacion,
                        sad.id_fuente,
                        sad.id_organismo,
						sad.id_usuario_reg,
						sad.fecha_reg,
						sad.id_usuario_ai,
						sad.usuario_ai,
						sad.id_usuario_mod,
						sad.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        pro.rotulo_comercial as beneficiario,
                        sad.banco_benef,
                        sad.cuenta_benef,
                        sad.banco_origen,
                        sad.cta_origen,
                        sad.libreta_origen,
                        sad.usuario_apro,
                        sad.monto_benef,
                        sad.multa,
                        sad.retencion,
                        sad.liquido_pagable,
                        sad.cuenta_contable,
                        sad.sisin,
                        sad.otfin,
                        sad.usuario_firm,
                        sad.cod_multa,
                        sad.cod_retencion,
                        sad.total_retencion,
                        sad.mes_rdo,
                        sad.tipo_rdo,
                        sad.tipo_contrato
						from sigep.tsigep_adq_det sad
						inner join segu.tusuario usu1 on usu1.id_usuario = sad.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = sad.id_usuario_mod
                        left join sigep.tsigep_adq sigad on sigad.id_sigep_adq = sad.id_sigep_adq
                        left join sigep.tmoneda smo on smo.moneda = sad.moneda
                        left join param.tmoneda mo on mo.id_moneda = smo.id_moneda
                        left join sigep.tdocumento_respaldo doc on doc.documento_respaldo = sad.tipo_doc_rdo
                        left join param.tproveedor pro on pro.id_beneficiario = sad.beneficiario
                        where';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
--raise notice 'v_consulta %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_SAD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rzabala
 	#FECHA:		25-03-2019 15:50:47
	***********************************/

	elsif(p_transaccion='SIGEP_SAD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_sigep_adq_det)
					    from sigep.tsigep_adq_det sad
					    inner join segu.tusuario usu1 on usu1.id_usuario = sad.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = sad.id_usuario_mod
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

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
PARALLEL UNSAFE
COST 100;
