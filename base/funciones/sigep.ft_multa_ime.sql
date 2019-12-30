CREATE OR REPLACE FUNCTION sigep.ft_multa_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_multa_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tdocumento_respaldo'
 AUTOR: 		 Maylee Perez Pastor
 FECHA:	        16-10-2019 15:11:16
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
	v_id_multa				integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_multa_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_MULTA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		16-10-2019 15:11:16
	***********************************/

	if(p_transaccion='SIGEP_MULTA_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tmulta(
			codigo,
			desc_multa,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			v_parametros.desc_multa,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_multa into v_id_multa;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DocumentoRespaldo almacenado(a) con exito (id_multa'||v_id_multa||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_multa',v_id_multa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_MULTA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		16-10-2019 15:11:16
	***********************************/

	elsif(p_transaccion='SIGEP_MULTA_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tmulta set
			codigo = v_parametros.codigo,
			desc_multa = v_parametros.desc_multa,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_multa=v_parametros.id_multa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DocumentoRespaldo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_multa',v_parametros.id_multa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_MULTA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		16-10-2019 15:11:16
	***********************************/

	elsif(p_transaccion='SIGEP_MULTA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tmulta
            where id_multa=v_parametros.id_multa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DocumentoRespaldo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_multa',v_parametros.id_multa::varchar);

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
PARALLEL UNSAFE
COST 100;
