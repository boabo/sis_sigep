CREATE OR REPLACE FUNCTION sigep.ft_proyecto_actividad_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_proyecto_actividad_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tproyecto_actividad'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 21:27:18
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

	v_nombre_funcion = 'sigep.ft_proyecto_actividad_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ACT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:18
	***********************************/

	if(p_transaccion='SIGEP_PRO_ACT_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pro_act.id_proyecto_actividad,
						pro_act.id_programa,
						pro_act.desc_catprg,
						pro_act.id_catprg,
						pro_act.id_categoria_programatica,
						pro_act.programa,
						pro_act.id_entidad,
						pro_act.proyecto,
						pro_act.nivel,
						pro_act.estado_reg,
						pro_act.actividad,
						pro_act.id_usuario_ai,
						pro_act.id_usuario_reg,
						pro_act.fecha_reg,
						pro_act.usuario_ai,
						pro_act.fecha_mod,
						pro_act.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tcp.descripcion::varchar as desc_cat_prog
						from sigep.tproyecto_actividad pro_act
						inner join segu.tusuario usu1 on usu1.id_usuario = pro_act.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pro_act.id_usuario_mod
                        left join pre.tcategoria_programatica tcp on tcp.id_categoria_programatica = pro_act.id_categoria_programatica
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ACT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:18
	***********************************/

	elsif(p_transaccion='SIGEP_PRO_ACT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_proyecto_actividad)
					    from sigep.tproyecto_actividad pro_act
					    inner join segu.tusuario usu1 on usu1.id_usuario = pro_act.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pro_act.id_usuario_mod
                        left join pre.tcategoria_programatica tcp on tcp.id_categoria_programatica = pro_act.id_categoria_programatica
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