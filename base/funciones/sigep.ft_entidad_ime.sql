CREATE OR REPLACE FUNCTION sigep.ft_entidad_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_entidad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tentidad'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 15:54:21
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
	v_id_tentidad	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_entidad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_ENT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:21
	***********************************/

	if(p_transaccion='SIGEP_ENT_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tentidad(
			tuicion_entidad,
			estado_reg,
			sigla_entidad,
			entidad,
			desc_entidad,
			id_entidad,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
            id_institucion
          	) values(
			v_parametros.tuicion_entidad,
			'activo',
			v_parametros.sigla_entidad,
			v_parametros.entidad,
			v_parametros.desc_entidad,
			v_parametros.id_entidad,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.id_institucion

			)RETURNING id_entidad_boa into v_id_tentidad;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entidad almacenado(a) con exito (id_tentidad'||v_id_tentidad||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tentidad',v_id_tentidad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ENT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:21
	***********************************/

	elsif(p_transaccion='SIGEP_ENT_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tentidad set
			tuicion_entidad = v_parametros.tuicion_entidad,
			sigla_entidad = v_parametros.sigla_entidad,
			entidad = v_parametros.entidad,
			desc_entidad = v_parametros.desc_entidad,
			id_entidad = v_parametros.id_entidad,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_institucion = v_parametros.id_institucion
			where id_entidad_boa=v_parametros.id_entidad_boa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entidad modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tentidad',v_parametros.id_entidad_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ENT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:21
	***********************************/

	elsif(p_transaccion='SIGEP_ENT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tentidad
            where id_entidad_boa=v_parametros.id_entidad_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entidad eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tentidad',v_parametros.id_entidad_boa::varchar);

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