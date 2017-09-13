CREATE OR REPLACE FUNCTION sigep.ft_banco_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_banco_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tbanco'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 16:37:46
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
	v_id_banco_boa	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_banco_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_BANCO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:37:46
	***********************************/

	if(p_transaccion='SIGEP_BANCO_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tbanco(
			banco,
			id_institucion,
			desc_banco,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod,
            spt
          	) values(
			v_parametros.banco,
			v_parametros.id_institucion,
			v_parametros.desc_banco,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null,
			v_parametros.spt


			)RETURNING id_banco_boa into v_id_banco_boa;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Banco almacenado(a) con exito (id_banco_boa'||v_id_banco_boa||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_banco_boa',v_id_banco_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_BANCO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:37:46
	***********************************/

	elsif(p_transaccion='SIGEP_BANCO_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tbanco set
			banco = v_parametros.banco,
			id_institucion = v_parametros.id_institucion,
			desc_banco = v_parametros.desc_banco,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            spt = v_parametros.spt
			where id_banco_boa=v_parametros.id_banco_boa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Banco modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_banco_boa',v_parametros.id_banco_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_BANCO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:37:46
	***********************************/

	elsif(p_transaccion='SIGEP_BANCO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tbanco
            where id_banco_boa=v_parametros.id_banco_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Banco eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_banco_boa',v_parametros.id_banco_boa::varchar);

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