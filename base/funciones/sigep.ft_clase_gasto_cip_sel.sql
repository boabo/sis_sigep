CREATE OR REPLACE FUNCTION sigep.ft_clase_gasto_cip_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_clase_gasto_cip_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tclase_gasto_cip'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 15:28:46
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

	v_nombre_funcion = 'sigep.ft_clase_gasto_cip_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_GAS_CIP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:28:46
	***********************************/

	if(p_transaccion='SIGEP_GAS_CIP_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						gas_cip.id_clase_gasto_cip,
						gas_cip.estado_reg,
						gas_cip.desc_clase_gasto,
						gas_cip.id_clase_gasto,
						gas_cip.clase_gasto,
						gas_cip.id_usuario_reg,
						gas_cip.usuario_ai,
						gas_cip.fecha_reg,
						gas_cip.id_usuario_ai,
						gas_cip.id_usuario_mod,
						gas_cip.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        (''(''||tcg.codigo||'') - ''||tcg.nombre)::varchar as desc_clase_gas
						from sigep.tclase_gasto_cip gas_cip
						inner join segu.tusuario usu1 on usu1.id_usuario = gas_cip.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gas_cip.id_usuario_mod
                        left join pre.tclase_gasto tcg on tcg.id_clase_gasto = gas_cip.id_clase_gasto
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_GAS_CIP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:28:46
	***********************************/

	elsif(p_transaccion='SIGEP_GAS_CIP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_clase_gasto_cip)
					    from sigep.tclase_gasto_cip gas_cip
					    inner join segu.tusuario usu1 on usu1.id_usuario = gas_cip.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gas_cip.id_usuario_mod
                        left join pre.tclase_gasto tcg on tcg.id_clase_gasto = gas_cip.id_clase_gasto
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