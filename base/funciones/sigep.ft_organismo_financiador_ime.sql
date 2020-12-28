CREATE OR REPLACE FUNCTION sigep.ft_organismo_financiador_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_organismo_financiador_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.torganismo_financiador'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 15:25:07
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
	v_id_organismo_financiador	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_organismo_financiador_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_ORG_FIN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:25:07
	***********************************/

	if(p_transaccion='SIGEP_ORG_FIN_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.torganismo_financiador(
			estado_reg,
			desc_organismo,
			sigla_organismo,
			organismo,
			id_organismo,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
            id_cp_organismo_fin,
            id_gestion
          	) values(
			'activo',
			v_parametros.desc_organismo,
			v_parametros.sigla_organismo,
			v_parametros.organismo,
			v_parametros.id_organismo,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.id_cp_organismo_fin,
            v_parametros.id_gestion

			)RETURNING id_organismo_financiador into v_id_organismo_financiador;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','OrganismoFinanciador almacenado(a) con exito (id_organismo_financiador'||v_id_organismo_financiador||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_organismo_financiador',v_id_organismo_financiador::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ORG_FIN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:25:07
	***********************************/

	elsif(p_transaccion='SIGEP_ORG_FIN_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.torganismo_financiador set
			desc_organismo = v_parametros.desc_organismo,
			sigla_organismo = v_parametros.sigla_organismo,
			organismo = v_parametros.organismo,
			id_organismo = v_parametros.id_organismo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_cp_organismo_fin = v_parametros.id_cp_organismo_fin,
            id_gestion = v_parametros.id_gestion
			where id_organismo_financiador=v_parametros.id_organismo_financiador;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','OrganismoFinanciador modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_organismo_financiador',v_parametros.id_organismo_financiador::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ORG_FIN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:25:07
	***********************************/

	elsif(p_transaccion='SIGEP_ORG_FIN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.torganismo_financiador
            where id_organismo_financiador=v_parametros.id_organismo_financiador;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','OrganismoFinanciador eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_organismo_financiador',v_parametros.id_organismo_financiador::varchar);

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
