CREATE OR REPLACE FUNCTION sigep.ft_fuente_financiamiento_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_fuente_financiamiento_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tfuente_financiamiento'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 15:54:19
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
	v_id_fuente_financiamiento	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_fuente_financiamiento_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_FUE_FIN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:19
	***********************************/

	if(p_transaccion='SIGEP_FUE_FIN_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tfuente_financiamiento(
			estado_reg,
			fuente,
			sigla_fuente,
			desc_fuente,
			id_fuente,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
            id_cp_fuente_fin,
            id_gestion
          	) values(
			'activo',
			v_parametros.fuente,
			v_parametros.sigla_fuente,
			v_parametros.desc_fuente,
			v_parametros.id_fuente,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.id_cp_fuente_fin,
			v_parametros.id_gestion

			)RETURNING id_fuente_financiamiento into v_id_fuente_financiamiento;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','FuenteFinanciamiento almacenado(a) con exito (id_fuente_financiamiento'||v_id_fuente_financiamiento||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fuente_financiamiento',v_id_fuente_financiamiento::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_FUE_FIN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:19
	***********************************/

	elsif(p_transaccion='SIGEP_FUE_FIN_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tfuente_financiamiento set
			fuente = v_parametros.fuente,
			sigla_fuente = v_parametros.sigla_fuente,
			desc_fuente = v_parametros.desc_fuente,
			id_fuente = v_parametros.id_fuente,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_cp_fuente_fin = v_parametros.id_cp_fuente_fin,
            id_gestion = v_parametros.id_gestion
			where id_fuente_financiamiento=v_parametros.id_fuente_financiamiento;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','FuenteFinanciamiento modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fuente_financiamiento',v_parametros.id_fuente_financiamiento::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_FUE_FIN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:19
	***********************************/

	elsif(p_transaccion='SIGEP_FUE_FIN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tfuente_financiamiento
            where id_fuente_financiamiento=v_parametros.id_fuente_financiamiento;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','FuenteFinanciamiento eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fuente_financiamiento',v_parametros.id_fuente_financiamiento::varchar);

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