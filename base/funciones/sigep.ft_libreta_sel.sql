CREATE OR REPLACE FUNCTION sigep.ft_libreta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_libreta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tlibreta'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        08-09-2017 14:59:30
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

	v_nombre_funcion = 'sigep.ft_libreta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_LIBRETA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 14:59:30
	***********************************/

	if(p_transaccion='SIGEP_LIBRETA_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						libreta.id_libreta_boa,
						libreta.id_cuenta_bancaria,
						libreta.moneda,
						libreta.banco,
						libreta.estado_libre,
						libreta.desc_libreta,
						libreta.estado_reg,
						libreta.id_libreta,
						libreta.libreta,
						libreta.cuenta,
						libreta.id_usuario_reg,
						libreta.fecha_reg,
						libreta.usuario_ai,
						libreta.id_usuario_ai,
						libreta.fecha_mod,
						libreta.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        (''(''||tcb.nro_cuenta||'') - ''||tcb.denominacion)::varchar as desc_cuenta_banco
						from sigep.tlibreta libreta
						inner join segu.tusuario usu1 on usu1.id_usuario = libreta.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = libreta.id_usuario_mod
                        left join tes.tcuenta_bancaria tcb on tcb.id_cuenta_bancaria = libreta.id_cuenta_bancaria
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_LIBRETA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 14:59:30
	***********************************/

	elsif(p_transaccion='SIGEP_LIBRETA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_libreta_boa)
					    from sigep.tlibreta libreta
					    inner join segu.tusuario usu1 on usu1.id_usuario = libreta.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = libreta.id_usuario_mod
                        left join tes.tcuenta_bancaria tcb on tcb.id_cuenta_bancaria = libreta.id_cuenta_bancaria
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