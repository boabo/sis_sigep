CREATE OR REPLACE FUNCTION sigep.ft_moneda_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_moneda_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tmoneda'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 16:21:25
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
	v_id_moneda_boa	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_moneda_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_MONEDA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:21:25
	***********************************/

	if(p_transaccion='SIGEP_MONEDA_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tmoneda(
			moneda,
			id_moneda,
			desc_moneda,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod,
            pais
          	) values(
			v_parametros.moneda,
			v_parametros.id_moneda,
			v_parametros.desc_moneda,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null,
			v_parametros.pais

			)RETURNING id_moneda_boa into v_id_moneda_boa;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Moneda almacenado(a) con exito (id_moneda_boa'||v_id_moneda_boa||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_moneda_boa',v_id_moneda_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_MONEDA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:21:25
	***********************************/

	elsif(p_transaccion='SIGEP_MONEDA_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tmoneda set
			moneda = v_parametros.moneda,
			id_moneda = v_parametros.id_moneda,
			desc_moneda = v_parametros.desc_moneda,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            pais = v_parametros.pais
			where id_moneda_boa=v_parametros.id_moneda_boa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Moneda modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_moneda_boa',v_parametros.id_moneda_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_MONEDA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:21:25
	***********************************/

	elsif(p_transaccion='SIGEP_MONEDA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tmoneda
            where id_moneda_boa=v_parametros.id_moneda_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Moneda eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_moneda_boa',v_parametros.id_moneda_boa::varchar);

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