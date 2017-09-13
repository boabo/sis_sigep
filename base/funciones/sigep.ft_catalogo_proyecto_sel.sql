CREATE OR REPLACE FUNCTION sigep.ft_catalogo_proyecto_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_catalogo_proyecto_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tcatalogo_proyecto'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 21:31:34
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

	v_nombre_funcion = 'sigep.ft_catalogo_proyecto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_CAT_PRO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:31:34
	***********************************/

	if(p_transaccion='SIGEP_CAT_PRO_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cat_pro.id_catalogo_proyecto,
						cat_pro.id_cp_proyecto,
						cat_pro.id_catpry,
						cat_pro.sisin,
						cat_pro.desc_catpry,
						cat_pro.id_entidad,
						cat_pro.id_gestion,
						cat_pro.estado_reg,
						cat_pro.id_catprg,
						cat_pro.id_usuario_ai,
						cat_pro.fecha_reg,
						cat_pro.usuario_ai,
						cat_pro.id_usuario_reg,
						cat_pro.fecha_mod,
						cat_pro.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tg.gestion,
                        (''(''||tp.codigo||'')-''||tp.descripcion)::varchar as desc_proyecto
						from sigep.tcatalogo_proyecto cat_pro
						inner join segu.tusuario usu1 on usu1.id_usuario = cat_pro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cat_pro.id_usuario_mod
                        left join pre.tcp_proyecto tp on tp.id_cp_proyecto = cat_pro.id_cp_proyecto
                        inner join param.tgestion tg on tg.id_gestion = cat_pro.id_gestion
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_CAT_PRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:31:34
	***********************************/

	elsif(p_transaccion='SIGEP_CAT_PRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_catalogo_proyecto)
					    from sigep.tcatalogo_proyecto cat_pro
					    inner join segu.tusuario usu1 on usu1.id_usuario = cat_pro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cat_pro.id_usuario_mod
                        left join pre.tcp_proyecto tp on tp.id_cp_proyecto = cat_pro.id_cp_proyecto
                        inner join param.tgestion tg on tg.id_gestion = cat_pro.id_gestion
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