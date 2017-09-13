CREATE OR REPLACE FUNCTION sigep.ft_clase_gasto_sip_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_clase_gasto_sip_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tclase_gasto_sip'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 15:41:47
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

	v_nombre_funcion = 'sigep.ft_clase_gasto_sip_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_GAS_SIP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:41:47
	***********************************/

	if(p_transaccion='SIGEP_GAS_SIP_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						gas_sip.id_clase_gasto_sip,
						gas_sip.clase_gasto,
						gas_sip.estado_reg,
						gas_sip.desc_clase_gasto,
						gas_sip.id_clase_gasto,
						gas_sip.usuario_ai,
						gas_sip.fecha_reg,
						gas_sip.id_usuario_reg,
						gas_sip.id_usuario_ai,
						gas_sip.fecha_mod,
						gas_sip.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        (''(''||tcg.codigo||'') - ''||tcg.nombre)::varchar as desc_clase_gas
						from sigep.tclase_gasto_sip gas_sip
						inner join segu.tusuario usu1 on usu1.id_usuario = gas_sip.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gas_sip.id_usuario_mod
                        left join pre.tclase_gasto tcg on tcg.id_clase_gasto = gas_sip.id_clase_gasto
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_GAS_SIP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:41:47
	***********************************/

	elsif(p_transaccion='SIGEP_GAS_SIP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_clase_gasto_sip)
					    from sigep.tclase_gasto_sip gas_sip
					    inner join segu.tusuario usu1 on usu1.id_usuario = gas_sip.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gas_sip.id_usuario_mod
                        left join pre.tclase_gasto tcg on tcg.id_clase_gasto = gas_sip.id_clase_gasto
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