CREATE OR REPLACE FUNCTION sigep.ft_programa_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_programa_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tprograma'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 20:53:14
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
	v_id_programa_boa	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_programa_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:14
	***********************************/

	if(p_transaccion='SIGEP_PRO_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tprograma(
			id_cp_programa,
			id_gestion,
			programa,
			desc_catprg,
			id_entidad,
			nivel,
			estado_reg,
			id_catprg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_cp_programa,
			v_parametros.id_gestion,
			v_parametros.programa,
			v_parametros.desc_catprg,
			v_parametros.id_entidad,
			v_parametros.nivel,
			'activo',
			v_parametros.id_catprg,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null



			)RETURNING id_programa_boa into v_id_programa_boa;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Programa almacenado(a) con exito (id_programa_boa'||v_id_programa_boa||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_programa_boa',v_id_programa_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:14
	***********************************/

	elsif(p_transaccion='SIGEP_PRO_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tprograma set
			id_cp_programa = v_parametros.id_cp_programa,
			id_gestion = v_parametros.id_gestion,
			programa = v_parametros.programa,
			desc_catprg = v_parametros.desc_catprg,
			id_entidad = v_parametros.id_entidad,
			nivel = v_parametros.nivel,
			id_catprg = v_parametros.id_catprg,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_programa_boa=v_parametros.id_programa_boa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Programa modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_programa_boa',v_parametros.id_programa_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:14
	***********************************/

	elsif(p_transaccion='SIGEP_PRO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tprograma
            where id_programa_boa=v_parametros.id_programa_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Programa eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_programa_boa',v_parametros.id_programa_boa::varchar);

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