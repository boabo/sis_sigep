CREATE OR REPLACE FUNCTION sigep.ft_libreta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_libreta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tlibreta'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_libreta_boa	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_libreta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_LIBRETA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 14:59:30
	***********************************/

	if(p_transaccion='SIGEP_LIBRETA_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tlibreta(
			moneda,
			banco,
			estado_libre,
			desc_libreta,
			estado_reg,
			id_libreta,
			libreta,
			cuenta,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
			id_cuenta_bancaria
          	) values(
			v_parametros.moneda,
			v_parametros.banco,
			v_parametros.estado_libre,
			v_parametros.desc_libreta,
			'activo',
			v_parametros.id_libreta,
			v_parametros.libreta,
			v_parametros.cuenta,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.id_cuenta_bancaria

			)RETURNING id_libreta_boa into v_id_libreta_boa;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Libreta almacenado(a) con exito (id_libreta_boa'||v_id_libreta_boa||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libreta_boa',v_id_libreta_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_LIBRETA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 14:59:30
	***********************************/

	elsif(p_transaccion='SIGEP_LIBRETA_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tlibreta set
			moneda = v_parametros.moneda,
			banco = v_parametros.banco,
			estado_libre = v_parametros.estado_libre,
			desc_libreta = v_parametros.desc_libreta,
			id_libreta = v_parametros.id_libreta,
			libreta = v_parametros.libreta,
			cuenta = v_parametros.cuenta,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
			where id_libreta_boa=v_parametros.id_libreta_boa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Libreta modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libreta_boa',v_parametros.id_libreta_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_LIBRETA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 14:59:30
	***********************************/

	elsif(p_transaccion='SIGEP_LIBRETA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tlibreta
            where id_libreta_boa=v_parametros.id_libreta_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Libreta eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libreta_boa',v_parametros.id_libreta_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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