CREATE OR REPLACE FUNCTION sigep.ft_presupuesto_gasto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_presupuesto_gasto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tpresupuesto_gasto'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 21:27:23
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
	v_id_presupuesto_gasto	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_presupuesto_gasto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_PRE_GAS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:23
	***********************************/

	if(p_transaccion='SIGEP_PRE_GAS_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tpresupuesto_gasto(
			gestion,
			id_catpry,
			id_gestion,
			id_organismo,
			ppto_inicial,
			estado_reg,
			credito_disponible,
			id_catprg,
			id_fuente,
			id_ent_transferencia,
			id_ptogto,
			id_da,
			id_objeto,
			id_entidad,
			ppto_vigente,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_ue
          	) values(
			v_parametros.gestion,
			v_parametros.id_catpry,
			v_parametros.id_gestion,
			v_parametros.id_organismo,
			v_parametros.ppto_inicial,
			'activo',
			v_parametros.credito_disponible,
			v_parametros.id_catprg,
			v_parametros.id_fuente,
			v_parametros.id_ent_transferencia,
			v_parametros.id_ptogto,
			v_parametros.id_da,
			v_parametros.id_objeto,
			v_parametros.id_entidad,
			v_parametros.ppto_vigente,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.id_ue


			)RETURNING id_presupuesto_gasto into v_id_presupuesto_gasto;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PresupuestoGasto almacenado(a) con exito (id_presupuesto_gasto'||v_id_presupuesto_gasto||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_gasto',v_id_presupuesto_gasto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRE_GAS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:23
	***********************************/

	elsif(p_transaccion='SIGEP_PRE_GAS_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tpresupuesto_gasto set
			gestion = v_parametros.gestion,
			id_catpry = v_parametros.id_catpry,
			id_gestion = v_parametros.id_gestion,
			id_organismo = v_parametros.id_organismo,
			ppto_inicial = v_parametros.ppto_inicial,
			credito_disponible = v_parametros.credito_disponible,
			id_catprg = v_parametros.id_catprg,
			id_fuente = v_parametros.id_fuente,
			id_ent_transferencia = v_parametros.id_ent_transferencia,
			id_ptogto = v_parametros.id_ptogto,
			id_da = v_parametros.id_da,
			id_objeto = v_parametros.id_objeto,
			id_entidad = v_parametros.id_entidad,
			ppto_vigente = v_parametros.ppto_vigente,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_ue = v_parametros.id_ue
			where id_presupuesto_gasto=v_parametros.id_presupuesto_gasto;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PresupuestoGasto modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_gasto',v_parametros.id_presupuesto_gasto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRE_GAS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:23
	***********************************/

	elsif(p_transaccion='SIGEP_PRE_GAS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tpresupuesto_gasto
            where id_presupuesto_gasto=v_parametros.id_presupuesto_gasto;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PresupuestoGasto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_gasto',v_parametros.id_presupuesto_gasto::varchar);

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