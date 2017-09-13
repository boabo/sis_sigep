CREATE OR REPLACE FUNCTION sigep.ft_clase_gasto_sip_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_clase_gasto_sip_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tclase_gasto_sip'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 15:41:47
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
	v_id_clase_gasto_sip	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_clase_gasto_sip_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_GAS_SIP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:41:47
	***********************************/

	if(p_transaccion='SIGEP_GAS_SIP_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tclase_gasto_sip(
			clase_gasto,
			estado_reg,
			desc_clase_gasto,
			id_clase_gasto,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.clase_gasto,
			'activo',
			v_parametros.desc_clase_gasto,
			v_parametros.id_clase_gasto,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_clase_gasto_sip into v_id_clase_gasto_sip;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ClaseGastoSIP almacenado(a) con exito (id_clase_gasto_sip'||v_id_clase_gasto_sip||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_clase_gasto_sip',v_id_clase_gasto_sip::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_GAS_SIP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:41:47
	***********************************/

	elsif(p_transaccion='SIGEP_GAS_SIP_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tclase_gasto_sip set
			clase_gasto = v_parametros.clase_gasto,
			desc_clase_gasto = v_parametros.desc_clase_gasto,
			id_clase_gasto = v_parametros.id_clase_gasto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_clase_gasto_sip=v_parametros.id_clase_gasto_sip;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ClaseGastoSIP modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_clase_gasto_sip',v_parametros.id_clase_gasto_sip::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_GAS_SIP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 15:41:47
	***********************************/

	elsif(p_transaccion='SIGEP_GAS_SIP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tclase_gasto_sip
            where id_clase_gasto_sip=v_parametros.id_clase_gasto_sip;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ClaseGastoSIP eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_clase_gasto_sip',v_parametros.id_clase_gasto_sip::varchar);

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