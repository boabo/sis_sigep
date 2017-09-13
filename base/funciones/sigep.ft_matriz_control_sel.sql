CREATE OR REPLACE FUNCTION sigep.ft_matriz_control_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_matriz_control_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tmatriz_control'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        08-09-2017 18:56:26
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

	v_nombre_funcion = 'sigep.ft_matriz_control_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_MAT_CONT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 18:56:26
	***********************************/

	if(p_transaccion='SIGEP_MAT_CONT_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						mat_cont.id_matriz_control,
						mat_cont.estado_reg,
						mat_cont.id_libreta,
						mat_cont.libreta,
						mat_cont.cuenta,
						mat_cont.banco,
						mat_cont.fecha_reg,
						mat_cont.usuario_ai,
						mat_cont.id_usuario_reg,
						mat_cont.id_usuario_ai,
						mat_cont.id_usuario_mod,
						mat_cont.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from sigep.tmatriz_control mat_cont
						inner join segu.tusuario usu1 on usu1.id_usuario = mat_cont.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = mat_cont.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_MAT_CONT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 18:56:26
	***********************************/

	elsif(p_transaccion='SIGEP_MAT_CONT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_matriz_control)
					    from sigep.tmatriz_control mat_cont
					    inner join segu.tusuario usu1 on usu1.id_usuario = mat_cont.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = mat_cont.id_usuario_mod
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