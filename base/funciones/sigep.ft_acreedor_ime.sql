CREATE OR REPLACE FUNCTION sigep.ft_acreedor_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_acreedor_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tacreedor'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 16:04:47
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
	v_id_acreedor	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_acreedor_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_ACREE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:04:47
	***********************************/

	if(p_transaccion='SIGEP_ACREE_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tacreedor(
			acreedor,
			id_afp,
			de_ley,
			desc_acreedor,
			tipo_acreedor,
			estado_reg,
			id_tipo_obligacion_columna,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.acreedor,
			v_parametros.id_afp,
			v_parametros.de_ley,
			v_parametros.desc_acreedor,
			v_parametros.tipo_acreedor,
			'activo',
			v_parametros.id_tipo_obligacion_columna,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null



			)RETURNING id_acreedor into v_id_acreedor;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Acreedor almacenado(a) con exito (id_acreedor'||v_id_acreedor||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_acreedor',v_id_acreedor::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ACREE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:04:47
	***********************************/

	elsif(p_transaccion='SIGEP_ACREE_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tacreedor set
			acreedor = v_parametros.acreedor,
			id_afp = v_parametros.id_afp,
			de_ley = v_parametros.de_ley,
			desc_acreedor = v_parametros.desc_acreedor,
			tipo_acreedor = v_parametros.tipo_acreedor,
			id_tipo_obligacion_columna = v_parametros.id_tipo_obligacion_columna,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_acreedor=v_parametros.id_acreedor;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Acreedor modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_acreedor',v_parametros.id_acreedor::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ACREE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:04:47
	***********************************/

	elsif(p_transaccion='SIGEP_ACREE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tacreedor
            where id_acreedor=v_parametros.id_acreedor;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Acreedor eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_acreedor',v_parametros.id_acreedor::varchar);

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