CREATE OR REPLACE FUNCTION sigep.ft_unidad_ejecutora_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_unidad_ejecutora_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tunidad_ejecutora'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 20:53:10
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

	v_nombre_funcion = 'sigep.ft_unidad_ejecutora_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_UNI_EJE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:10
	***********************************/

	if(p_transaccion='SIGEP_UNI_EJE_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						uni_eje.id_unidad_ejecutora_boa,
						uni_eje.ue,
						uni_eje.desc_ue,
						uni_eje.id_da,
						uni_eje.id_unidad_ejecutora,
						uni_eje.estado_reg,
						uni_eje.id_gestion,
						uni_eje.id_ue,
						uni_eje.id_usuario_ai,
						uni_eje.fecha_reg,
						uni_eje.usuario_ai,
						uni_eje.id_usuario_reg,
						uni_eje.id_usuario_mod,
						uni_eje.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tg.gestion,
                        tue.nombre as desc_unidad_ejec
						from sigep.tunidad_ejecutora uni_eje
						inner join segu.tusuario usu1 on usu1.id_usuario = uni_eje.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = uni_eje.id_usuario_mod
                        left JOIN param.tgestion tg ON tg.id_gestion = uni_eje.id_gestion
                        left join pre.tunidad_ejecutora tue on tue.id_unidad_ejecutora = uni_eje.id_unidad_ejecutora
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_UNI_EJE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:10
	***********************************/

	elsif(p_transaccion='SIGEP_UNI_EJE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_unidad_ejecutora_boa)
					    from sigep.tunidad_ejecutora uni_eje
					    inner join segu.tusuario usu1 on usu1.id_usuario = uni_eje.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = uni_eje.id_usuario_mod
                        left JOIN param.tgestion tg ON tg.id_gestion = uni_eje.id_gestion
                        left join pre.tunidad_ejecutora tue on tue.id_unidad_ejecutora = uni_eje.id_unidad_ejecutora
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