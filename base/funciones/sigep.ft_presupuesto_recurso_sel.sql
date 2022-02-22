CREATE OR REPLACE FUNCTION sigep.ft_presupuesto_recurso_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_presupuesto_recurso_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tpresupuesto_gasto'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 21:27:23
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

	v_nombre_funcion = 'sigep.ft_presupuesto_recurso_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_PRE_GAS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:23
	***********************************/

	if(p_transaccion='SIGEP_PRE_REC_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pre_gas.id_presupuesto_recurso,
						pre_gas.gestion,
                        pre_gas.id_ue,
						pre_gas.id_catpry,
						pre_gas.id_gestion,
						pre_gas.id_organismo,
						pre_gas.ppto_inicial,
						pre_gas.estado_reg,
						pre_gas.credito_disponible,
						pre_gas.id_catprg,
						pre_gas.id_fuente,
						pre_gas.id_ent_transferencia,
						pre_gas.id_ptorec,
						pre_gas.id_da,
						pre_gas.id_objeto,
						pre_gas.id_entidad,
						pre_gas.ppto_vigente,
						pre_gas.usuario_ai,
						pre_gas.fecha_reg,
						pre_gas.id_usuario_reg,
						pre_gas.id_usuario_ai,
						pre_gas.fecha_mod,
						pre_gas.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        pre_gas.id_rubro,
                        pre_gas.id_ent_otorgante,
                        pre_gas.devengado,
                        pre_gas.percibido
						from sigep.tpresupuesto_recurso pre_gas
						inner join segu.tusuario usu1 on usu1.id_usuario = pre_gas.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pre_gas.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRE_GAS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:23
	***********************************/

	elsif(p_transaccion='SIGEP_PRE_REC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_presupuesto_recurso)
					    from sigep.tpresupuesto_recurso pre_gas
					    inner join segu.tusuario usu1 on usu1.id_usuario = pre_gas.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pre_gas.id_usuario_mod
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

ALTER FUNCTION sigep.ft_presupuesto_recurso_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;