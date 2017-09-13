CREATE OR REPLACE FUNCTION sigep.ft_documento_respaldo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_documento_respaldo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tdocumento_respaldo'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 15:11:16
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'sigep.ft_documento_respaldo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_DOC_RESP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:11:16
	***********************************/

	if(p_transaccion='SIGEP_DOC_RESP_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						doc_resp.id_documento_respaldo,
						doc_resp.documento_respaldo,
						doc_resp.desc_documento,
						doc_resp.sigla,
						doc_resp.estado_reg,
						doc_resp.id_usuario_ai,
						doc_resp.id_usuario_reg,
						doc_resp.fecha_reg,
						doc_resp.usuario_ai,
						doc_resp.fecha_mod,
						doc_resp.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from sigep.tdocumento_respaldo doc_resp
						inner join segu.tusuario usu1 on usu1.id_usuario = doc_resp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = doc_resp.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_DOC_RESP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:11:16
	***********************************/

	elsif(p_transaccion='SIGEP_DOC_RESP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_documento_respaldo)
					    from sigep.tdocumento_respaldo doc_resp
					    inner join segu.tusuario usu1 on usu1.id_usuario = doc_resp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = doc_resp.id_usuario_mod
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
COST 100;