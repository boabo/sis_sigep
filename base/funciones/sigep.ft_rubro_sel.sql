CREATE OR REPLACE FUNCTION sigep.ft_rubro_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_rubro_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tobjeto_gasto'
 AUTOR: 		 (ruben.guancollo)
 FECHA:	        09-08-2021 11:00:00
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

	v_nombre_funcion = 'sigep.ft_rubro_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_RUB_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		ruben.guancollo
 	#FECHA:		09-08-2021 11:00:00
	***********************************/

	if(p_transaccion='SIGEP_RUB_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						rub.id_recurso_rubro ,
						rub.id_partida,
						rub.id_gestion,
						rub.desc_rubro,
						rub.nivel,
						rub.rubro,
						rub.estado_reg,
						rub.id_rubro,
						rub.id_usuario_reg,
						rub.fecha_reg,
						rub.id_usuario_mod,
						rub.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tp.codigo,
                        tp.nombre_partida,
						tg.gestion

						from sigep.trubro rub
						inner join segu.tusuario usu1 on usu1.id_usuario = rub.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rub.id_usuario_mod
                        LEFT JOIN pre.tpartida tp ON tp.id_partida = rub.id_partida
                        LEFT JOIN param.tgestion tg ON tg.id_gestion = rub.id_gestion
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_RUB_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		ruben.guancollo
 	#FECHA:		09-08-2021 11:00:00
	***********************************/

	elsif(p_transaccion='SIGEP_RUB_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_recurso_rubro)
					    from sigep.trubro rub
					    inner join segu.tusuario usu1 on usu1.id_usuario = rub.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rub.id_usuario_mod
                        LEFT JOIN pre.tpartida tp ON tp.id_partida = rub.id_partida
                        LEFT JOIN param.tgestion tg ON tg.id_gestion = rub.id_gestion
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

ALTER FUNCTION sigep.ft_rubro_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;