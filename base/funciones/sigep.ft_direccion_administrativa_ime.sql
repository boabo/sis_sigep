CREATE OR REPLACE FUNCTION sigep.ft_direccion_administrativa_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_direccion_administrativa_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tdireccion_administrativa'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 15:01:48
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
	v_id_direccion_administrativa_boa	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_direccion_administrativa_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_DIR_ADM_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 15:01:48
	***********************************/

	if(p_transaccion='SIGEP_DIR_ADM_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tdireccion_administrativa(
			id_direccion_administrativa,
			id_gestion,
			id_da,
			tipo_da,
			estado_reg,
			da,
			id_entidad,
			desc_da,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_direccion_administrativa,
			v_parametros.id_gestion,
			v_parametros.id_da,
			v_parametros.tipo_da,
			'activo',
			v_parametros.da,
			v_parametros.id_entidad,
			v_parametros.desc_da,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_direccion_administrativa_boa into v_id_direccion_administrativa_boa;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DireccionAdministrativa almacenado(a) con exito (id_direccion_administrativa_boa'||v_id_direccion_administrativa_boa||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_direccion_administrativa_boa',v_id_direccion_administrativa_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_DIR_ADM_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 15:01:48
	***********************************/

	elsif(p_transaccion='SIGEP_DIR_ADM_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tdireccion_administrativa set
			id_direccion_administrativa = v_parametros.id_direccion_administrativa,
			id_gestion = v_parametros.id_gestion,
			id_da = v_parametros.id_da,
			tipo_da = v_parametros.tipo_da,
			da = v_parametros.da,
			id_entidad = v_parametros.id_entidad,
			desc_da = v_parametros.desc_da,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_direccion_administrativa_boa=v_parametros.id_direccion_administrativa_boa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DireccionAdministrativa modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_direccion_administrativa_boa',v_parametros.id_direccion_administrativa_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_DIR_ADM_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 15:01:48
	***********************************/

	elsif(p_transaccion='SIGEP_DIR_ADM_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tdireccion_administrativa
            where id_direccion_administrativa_boa=v_parametros.id_direccion_administrativa_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DireccionAdministrativa eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_direccion_administrativa_boa',v_parametros.id_direccion_administrativa_boa::varchar);

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