CREATE OR REPLACE FUNCTION sigep.ft_entidad_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_entidad_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tentidad'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 15:54:21
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

	v_nombre_funcion = 'sigep.ft_entidad_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_ENT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:21
	***********************************/

	if(p_transaccion='SIGEP_ENT_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						ent.id_entidad_boa,
                        ent.id_institucion,
						ent.tuicion_entidad,
						ent.estado_reg,
						ent.sigla_entidad,
						ent.entidad,
						ent.desc_entidad,
						ent.id_entidad,
						ent.usuario_ai,
						ent.fecha_reg,
						ent.id_usuario_reg,
						ent.id_usuario_ai,
						ent.id_usuario_mod,
						ent.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tin.nombre as desc_institucion
						from sigep.tentidad ent
						inner join segu.tusuario usu1 on usu1.id_usuario = ent.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ent.id_usuario_mod
                        left join param.tinstitucion tin on tin.id_institucion = ent.id_institucion
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ENT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:21
	***********************************/

	elsif(p_transaccion='SIGEP_ENT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_entidad_boa)
					    from sigep.tentidad ent
					    inner join segu.tusuario usu1 on usu1.id_usuario = ent.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ent.id_usuario_mod
                        left join param.tinstitucion tin on tin.id_institucion = ent.id_institucion
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