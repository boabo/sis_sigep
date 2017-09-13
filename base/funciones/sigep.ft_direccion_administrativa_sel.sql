CREATE OR REPLACE FUNCTION sigep.ft_direccion_administrativa_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_direccion_administrativa_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tdireccion_administrativa'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 15:01:48
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

	v_nombre_funcion = 'sigep.ft_direccion_administrativa_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_DIR_ADM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 15:01:48
	***********************************/

	if(p_transaccion='SIGEP_DIR_ADM_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						dir_adm.id_direccion_administrativa_boa,
						dir_adm.id_direccion_administrativa,
						dir_adm.id_gestion,
						dir_adm.id_da,
						dir_adm.tipo_da,
						dir_adm.estado_reg,
						dir_adm.da,
						dir_adm.id_entidad,
						dir_adm.desc_da,
						dir_adm.id_usuario_reg,
						dir_adm.fecha_reg,
						dir_adm.usuario_ai,
						dir_adm.id_usuario_ai,
						dir_adm.fecha_mod,
						dir_adm.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tg.gestion,
                        tda.nombre as desc_direccion_admin
						from sigep.tdireccion_administrativa dir_adm
						inner join segu.tusuario usu1 on usu1.id_usuario = dir_adm.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = dir_adm.id_usuario_mod
                        inner JOIN param.tgestion tg ON tg.id_gestion = dir_adm.id_gestion
                        left join pre.tdireccion_administrativa tda on tda.id_direccion_administrativa = dir_adm.id_direccion_administrativa
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_DIR_ADM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 15:01:48
	***********************************/

	elsif(p_transaccion='SIGEP_DIR_ADM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_direccion_administrativa_boa)
					    from sigep.tdireccion_administrativa dir_adm
					    inner join segu.tusuario usu1 on usu1.id_usuario = dir_adm.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = dir_adm.id_usuario_mod
                        inner JOIN param.tgestion tg ON tg.id_gestion = dir_adm.id_gestion
                        left join pre.tdireccion_administrativa tda on tda.id_direccion_administrativa = dir_adm.id_direccion_administrativa
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