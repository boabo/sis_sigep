CREATE OR REPLACE FUNCTION sigep.ft_programa_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_programa_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tprograma'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 20:53:14
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

	v_nombre_funcion = 'sigep.ft_programa_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:14
	***********************************/

	if(p_transaccion='SIGEP_PRO_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pro.id_programa_boa,
						pro.id_cp_programa,
						pro.id_gestion,
						pro.programa,
						pro.desc_catprg,
						pro.id_entidad,
						pro.nivel,
						pro.estado_reg,
						pro.id_catprg,
						pro.id_usuario_ai,
						pro.fecha_reg,
						pro.usuario_ai,
						pro.id_usuario_reg,
						pro.id_usuario_mod,
						pro.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tg.gestion,
                        tp.descripcion as desc_programa
						from sigep.tprograma pro
						inner join segu.tusuario usu1 on usu1.id_usuario = pro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pro.id_usuario_mod
                        inner JOIN param.tgestion tg ON tg.id_gestion = pro.id_gestion
                        left join pre.tcp_programa tp on tp.id_cp_programa = pro.id_cp_programa
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:14
	***********************************/

	elsif(p_transaccion='SIGEP_PRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_programa_boa)
					    from sigep.tprograma pro
					    inner join segu.tusuario usu1 on usu1.id_usuario = pro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pro.id_usuario_mod
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