CREATE OR REPLACE FUNCTION sigep.ft_matriz_control_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_matriz_control_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tmatriz_control'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        08-09-2017 18:56:26
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
	v_id_matriz_control	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_matriz_control_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_MAT_CONT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 18:56:26
	***********************************/

	if(p_transaccion='SIGEP_MAT_CONT_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tmatriz_control(
			estado_reg,
			id_libreta,
			libreta,
			cuenta,
			banco,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_libreta,
			v_parametros.libreta,
			v_parametros.cuenta,
			v_parametros.banco,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_matriz_control into v_id_matriz_control;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MatrizContro almacenado(a) con exito (id_matriz_control'||v_id_matriz_control||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_matriz_control',v_id_matriz_control::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_MAT_CONT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 18:56:26
	***********************************/

	elsif(p_transaccion='SIGEP_MAT_CONT_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tmatriz_control set
			id_libreta = v_parametros.id_libreta,
			libreta = v_parametros.libreta,
			cuenta = v_parametros.cuenta,
			banco = v_parametros.banco,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_matriz_control=v_parametros.id_matriz_control;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MatrizContro modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_matriz_control',v_parametros.id_matriz_control::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_MAT_CONT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		08-09-2017 18:56:26
	***********************************/

	elsif(p_transaccion='SIGEP_MAT_CONT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tmatriz_control
            where id_matriz_control=v_parametros.id_matriz_control;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MatrizContro eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_matriz_control',v_parametros.id_matriz_control::varchar);

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