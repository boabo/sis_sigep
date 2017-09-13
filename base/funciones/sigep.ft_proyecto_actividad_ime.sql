CREATE OR REPLACE FUNCTION sigep.ft_proyecto_actividad_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_proyecto_actividad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tproyecto_actividad'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 21:27:18
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
	v_id_proyecto_actividad	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_proyecto_actividad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ACT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:18
	***********************************/

	if(p_transaccion='SIGEP_PRO_ACT_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tproyecto_actividad(
			id_programa,
			desc_catprg,
			id_catprg,
			id_categoria_programatica,
			programa,
			id_entidad,
			proyecto,
			nivel,
			estado_reg,
			actividad,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_programa,
			v_parametros.desc_catprg,
			v_parametros.id_catprg,
			v_parametros.id_categoria_programatica,
			v_parametros.programa,
			v_parametros.id_entidad,
			v_parametros.proyecto,
			v_parametros.nivel,
			'activo',
			v_parametros.actividad,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_proyecto_actividad into v_id_proyecto_actividad;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ProyectoActividad almacenado(a) con exito (id_proyecto_actividad'||v_id_proyecto_actividad||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_actividad',v_id_proyecto_actividad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ACT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:18
	***********************************/

	elsif(p_transaccion='SIGEP_PRO_ACT_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tproyecto_actividad set
			id_programa = v_parametros.id_programa,
			desc_catprg = v_parametros.desc_catprg,
			id_catprg = v_parametros.id_catprg,
			id_categoria_programatica = v_parametros.id_categoria_programatica,
			programa = v_parametros.programa,
			id_entidad = v_parametros.id_entidad,
			proyecto = v_parametros.proyecto,
			nivel = v_parametros.nivel,
			actividad = v_parametros.actividad,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_proyecto_actividad=v_parametros.id_proyecto_actividad;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ProyectoActividad modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_actividad',v_parametros.id_proyecto_actividad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ACT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:18
	***********************************/

	elsif(p_transaccion='SIGEP_PRO_ACT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tproyecto_actividad
            where id_proyecto_actividad=v_parametros.id_proyecto_actividad;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ProyectoActividad eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_actividad',v_parametros.id_proyecto_actividad::varchar);

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