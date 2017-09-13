CREATE OR REPLACE FUNCTION sigep.ft_otfin_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_otfin_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.totfin'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 18:59:47
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
	v_id_otfin	integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_otfin_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_OTFIN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 18:59:47
	***********************************/

	if(p_transaccion='SIGEP_OTFIN_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.totfin(
			otfin,
			estado_reg,
			id_entidad,
			desc_otfin,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.otfin,
			'activo',
			v_parametros.id_entidad,
			v_parametros.desc_otfin,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_otfin into v_id_otfin;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Otfin almacenado(a) con exito (id_otfin'||v_id_otfin||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_otfin',v_id_otfin::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_OTFIN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 18:59:47
	***********************************/

	elsif(p_transaccion='SIGEP_OTFIN_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.totfin set
			otfin = v_parametros.otfin,
			id_entidad = v_parametros.id_entidad,
			desc_otfin = v_parametros.desc_otfin,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_otfin=v_parametros.id_otfin;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Otfin modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_otfin',v_parametros.id_otfin::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_OTFIN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 18:59:47
	***********************************/

	elsif(p_transaccion='SIGEP_OTFIN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.totfin
            where id_otfin=v_parametros.id_otfin;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Otfin eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_otfin',v_parametros.id_otfin::varchar);

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