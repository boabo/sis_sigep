CREATE OR REPLACE FUNCTION sigep.ft_objeto_gasto_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_objeto_gasto_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tobjeto_gasto'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 13:18:08
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

	v_nombre_funcion = 'sigep.ft_objeto_gasto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_OBJ_GAS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 13:18:08
	***********************************/

	if(p_transaccion='SIGEP_OBJ_GAS_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						obj_gas.id_objeto_gasto,
						obj_gas.id_partida,
						obj_gas.id_gestion,
						obj_gas.desc_objeto,
						obj_gas.nivel,
						obj_gas.objeto,
						obj_gas.estado_reg,
						obj_gas.id_objeto,
						obj_gas.id_usuario_ai,
						obj_gas.id_usuario_reg,
						obj_gas.fecha_reg,
						obj_gas.usuario_ai,
						obj_gas.id_usuario_mod,
						obj_gas.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tp.codigo,
                        tp.nombre_partida,
                        tg.gestion
						from sigep.tobjeto_gasto obj_gas
						inner join segu.tusuario usu1 on usu1.id_usuario = obj_gas.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj_gas.id_usuario_mod
                        LEFT JOIN pre.tpartida tp ON tp.id_partida = obj_gas.id_partida
                        LEFT JOIN param.tgestion tg ON tg.id_gestion = obj_gas.id_gestion
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_OBJ_GAS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 13:18:08
	***********************************/

	elsif(p_transaccion='SIGEP_OBJ_GAS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_objeto_gasto)
					    from sigep.tobjeto_gasto obj_gas
					    inner join segu.tusuario usu1 on usu1.id_usuario = obj_gas.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj_gas.id_usuario_mod
                        LEFT JOIN pre.tpartida tp ON tp.id_partida = obj_gas.id_partida
                        LEFT JOIN param.tgestion tg ON tg.id_gestion = obj_gas.id_gestion
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
