CREATE OR REPLACE FUNCTION sigep.ft_fuente_financiamiento_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_fuente_financiamiento_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tfuente_financiamiento'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 15:54:19
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

	v_nombre_funcion = 'sigep.ft_fuente_financiamiento_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_FUE_FIN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:19
	***********************************/

	if(p_transaccion='SIGEP_FUE_FIN_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						fue_fin.id_fuente_financiamiento,
                        fue_fin.id_cp_fuente_fin,
                        fue_fin.id_gestion,
						fue_fin.estado_reg,
						fue_fin.fuente,
						fue_fin.sigla_fuente,
						fue_fin.desc_fuente,
						fue_fin.id_fuente,
						fue_fin.usuario_ai,
						fue_fin.fecha_reg,
						fue_fin.id_usuario_reg,
						fue_fin.id_usuario_ai,
						fue_fin.id_usuario_mod,
						fue_fin.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tg.gestion,
                        tff.descripcion as desc_fuente_fin
						from sigep.tfuente_financiamiento fue_fin
						inner join segu.tusuario usu1 on usu1.id_usuario = fue_fin.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fue_fin.id_usuario_mod
                        inner join param.tgestion tg on tg.id_gestion = fue_fin.id_gestion
                        left join pre.tcp_fuente_fin tff on tff.id_cp_fuente_fin = fue_fin.id_cp_fuente_fin
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_FUE_FIN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:19
	***********************************/

	elsif(p_transaccion='SIGEP_FUE_FIN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_fuente_financiamiento)
					    from sigep.tfuente_financiamiento fue_fin
					    inner join segu.tusuario usu1 on usu1.id_usuario = fue_fin.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fue_fin.id_usuario_mod
                        inner join param.tgestion tg on tg.id_gestion = fue_fin.id_gestion
                        left join pre.tcp_fuente_fin tff on tff.id_cp_fuente_fin = fue_fin.id_cp_fuente_fin
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