CREATE OR REPLACE FUNCTION sigep.ft_rubro_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_rubro_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.trubro'
 AUTOR: 		 (ruben.guancollo)
 FECHA:	        10-08-2021 15:30:00
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
	v_id_recurso_rubro	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_rubro_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_RUB_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		ruben.guancollo
 	#FECHA:		10-08-2021 15:30:00
	***********************************/

	if(p_transaccion='SIGEP_RUB_INS')then

        begin

        	--Sentencia de la insercion
        	insert into sigep.trubro(
			id_partida,
			id_gestion,
			desc_rubro,
			nivel,
			rubro,
			reg_estado,
			id_rubro,
			--id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			--usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_partida,
			v_parametros.id_gestion,
			v_parametros.desc_rubro,
			v_parametros.nivel,
			v_parametros.rubro,
			'activo',
			v_parametros.id_rubro,
			--v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			--v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_recurso_rubro into v_id_recurso_rubro;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetoGasto almacenado(a) con exito (id_objeto_gasto'||v_id_recurso_rubro||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objeto_gasto',v_id_recurso_rubro::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_RUB_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		ruben.guancollo
 	#FECHA:		10-08-2021 15:30:00
	***********************************/

	elsif(p_transaccion='SIGEP_RUB_MOD')then

		begin
        	--raise exception 'v_parametros.id_gestion: %',v_parametros.id_gestion;
			--Sentencia de la modificacion
			update sigep.trubro set
			id_partida = v_parametros.id_partida,
			id_gestion = v_parametros.id_gestion,
			desc_rubro = v_parametros.desc_rubro,
			nivel = v_parametros.nivel,
			rubro = v_parametros.rubro,
			id_rubro = v_parametros.id_rubro,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			--id_usuario_ai = v_parametros._id_usuario_ai,
			--usuario_ai = v_parametros._nombre_usuario_ai
			where id_recurso_rubro=v_parametros.id_recurso_rubro;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetoGasto modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objeto_gasto',v_parametros.id_recurso_rubro::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_RUB_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		ruben.guancollo
 	#FECHA:		10-08-2021 16:30:00
	***********************************/

	elsif(p_transaccion='SIGEP_RUB_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.trubro
            where id_recurso_rubro=v_parametros.id_recurso_rubro;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetoGasto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objeto_gasto',v_parametros.id_recurso_rubro::varchar);

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

ALTER FUNCTION sigep.ft_rubro_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;