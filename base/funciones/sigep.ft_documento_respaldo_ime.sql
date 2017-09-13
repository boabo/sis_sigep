CREATE OR REPLACE FUNCTION sigep.ft_documento_respaldo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_documento_respaldo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tdocumento_respaldo'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 15:11:16
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
	v_id_documento_respaldo	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_documento_respaldo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_DOC_RESP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:11:16
	***********************************/

	if(p_transaccion='SIGEP_DOC_RESP_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tdocumento_respaldo(
			documento_respaldo,
			desc_documento,
			sigla,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.documento_respaldo,
			v_parametros.desc_documento,
			v_parametros.sigla,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_documento_respaldo into v_id_documento_respaldo;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DocumentoRespaldo almacenado(a) con exito (id_documento_respaldo'||v_id_documento_respaldo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_respaldo',v_id_documento_respaldo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_DOC_RESP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:11:16
	***********************************/

	elsif(p_transaccion='SIGEP_DOC_RESP_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tdocumento_respaldo set
			documento_respaldo = v_parametros.documento_respaldo,
			desc_documento = v_parametros.desc_documento,
			sigla = v_parametros.sigla,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_documento_respaldo=v_parametros.id_documento_respaldo;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DocumentoRespaldo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_respaldo',v_parametros.id_documento_respaldo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_DOC_RESP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:11:16
	***********************************/

	elsif(p_transaccion='SIGEP_DOC_RESP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tdocumento_respaldo
            where id_documento_respaldo=v_parametros.id_documento_respaldo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DocumentoRespaldo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_respaldo',v_parametros.id_documento_respaldo::varchar);

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