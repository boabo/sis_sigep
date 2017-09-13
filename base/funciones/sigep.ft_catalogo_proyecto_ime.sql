CREATE OR REPLACE FUNCTION sigep.ft_catalogo_proyecto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_catalogo_proyecto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tcatalogo_proyecto'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 21:31:34
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
	v_id_catalogo_proyecto	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_catalogo_proyecto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_CAT_PRO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:31:34
	***********************************/

	if(p_transaccion='SIGEP_CAT_PRO_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tcatalogo_proyecto(
			id_cp_proyecto,
			id_catpry,
			sisin,
			desc_catpry,
			id_entidad,
			id_gestion,
			estado_reg,
			id_catprg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_cp_proyecto,
			v_parametros.id_catpry,
			v_parametros.sisin,
			v_parametros.desc_catpry,
			v_parametros.id_entidad,
			v_parametros.id_gestion,
			'activo',
			v_parametros.id_catprg,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null



			)RETURNING id_catalogo_proyecto into v_id_catalogo_proyecto;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CatalogoProyecto almacenado(a) con exito (id_catalogo_proyecto'||v_id_catalogo_proyecto||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_catalogo_proyecto',v_id_catalogo_proyecto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_CAT_PRO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:31:34
	***********************************/

	elsif(p_transaccion='SIGEP_CAT_PRO_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tcatalogo_proyecto set
			id_cp_proyecto = v_parametros.id_cp_proyecto,
			id_catpry = v_parametros.id_catpry,
			sisin = v_parametros.sisin,
			desc_catpry = v_parametros.desc_catpry,
			id_entidad = v_parametros.id_entidad,
			id_gestion = v_parametros.id_gestion,
			id_catprg = v_parametros.id_catprg,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_catalogo_proyecto=v_parametros.id_catalogo_proyecto;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CatalogoProyecto modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_catalogo_proyecto',v_parametros.id_catalogo_proyecto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_CAT_PRO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:31:34
	***********************************/

	elsif(p_transaccion='SIGEP_CAT_PRO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tcatalogo_proyecto
            where id_catalogo_proyecto=v_parametros.id_catalogo_proyecto;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CatalogoProyecto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_catalogo_proyecto',v_parametros.id_catalogo_proyecto::varchar);

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