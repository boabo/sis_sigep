CREATE OR REPLACE FUNCTION sigep.ft_sigade_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_sigade_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tsigade'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 18:46:18
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
	v_id_sigade	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_sigade_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_SIGAD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 18:46:18
	***********************************/

	if(p_transaccion='SIGEP_SIGAD_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tsigade(
			estado_reg,
			desc_sigade,
			tipo_deuda,
			sigade,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.desc_sigade,
			v_parametros.tipo_deuda,
			v_parametros.sigade,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_sigade into v_id_sigade;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigade almacenado(a) con exito (id_sigade'||v_id_sigade||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigade',v_id_sigade::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_SIGAD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 18:46:18
	***********************************/

	elsif(p_transaccion='SIGEP_SIGAD_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tsigade set
			desc_sigade = v_parametros.desc_sigade,
			tipo_deuda = v_parametros.tipo_deuda,
			sigade = v_parametros.sigade,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_sigade=v_parametros.id_sigade;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigade modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigade',v_parametros.id_sigade::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_SIGAD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 18:46:18
	***********************************/

	elsif(p_transaccion='SIGEP_SIGAD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tsigade
            where id_sigade=v_parametros.id_sigade;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigade eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigade',v_parametros.id_sigade::varchar);

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