CREATE OR REPLACE FUNCTION sigep.ft_unidad_ejecutora_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_unidad_ejecutora_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tunidad_ejecutora'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 20:53:10
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
	v_id_unidad_ejecutora	integer;


    v_id_gestion			integer;
    v_id_unidad_dos			integer;
    v_registros				record;

BEGIN

    v_nombre_funcion = 'sigep.ft_unidad_ejecutora_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_UNI_EJE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:10
	***********************************/

	if(p_transaccion='SIGEP_UNI_EJE_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tunidad_ejecutora(
			ue,
			desc_ue,
			id_da,
			id_unidad_ejecutora,
			estado_reg,
			id_gestion,
			id_ue,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.ue,
			v_parametros.desc_ue,
			v_parametros.id_da,
			v_parametros.id_unidad_ejecutora,
			'activo',
			v_parametros.id_gestion,
			v_parametros.id_ue,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null



			)RETURNING id_unidad_ejecutora_boa into v_id_unidad_ejecutora;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','UnidadEjecutora almacenado(a) con exito (id_unidad_ejecutora'||v_id_unidad_ejecutora||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_ejecutora_boa',v_id_unidad_ejecutora::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_UNI_EJE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:10
	***********************************/

	elsif(p_transaccion='SIGEP_UNI_EJE_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tunidad_ejecutora set
			ue = v_parametros.ue,
			desc_ue = v_parametros.desc_ue,
			id_da = v_parametros.id_da,
			id_unidad_ejecutora = v_parametros.id_unidad_ejecutora,
			id_gestion = v_parametros.id_gestion,
			id_ue = v_parametros.id_ue,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_unidad_ejecutora_boa=v_parametros.id_unidad_ejecutora_boa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','UnidadEjecutora modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_ejecutora_boa',v_parametros.id_unidad_ejecutora_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_UNI_EJE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 20:53:10
	***********************************/

	elsif(p_transaccion='SIGEP_UNI_EJE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tunidad_ejecutora
            where id_unidad_ejecutora_boa=v_parametros.id_unidad_ejecutora_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','UnidadEjecutora eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_ejecutora_boa',v_parametros.id_unidad_ejecutora_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'PRE_CLO_UNI_EJE_IME'
 	#DESCRIPCION:	Clonacion de Registros Unidad Ejecutora
 	#AUTOR:		franklin.espinoza
 	#FECHA:		18-01-2021 10:00:23
	***********************************/

	elsif(p_transaccion='PRE_CLO_UNI_EJE_IME')then

		begin

          select tg.id_gestion
          into v_id_gestion
          from param.tgestion tg
          where tg.gestion = date_part('year',current_date);

			for v_registros in select tue.id_ue,
                                      tue.id_da,
                                      tue.ue,
                                      tue.desc_ue,
                                      tue.id_unidad_ejecutora
        						from sigep.tunidad_ejecutora tue
                                where tue.id_gestion = v_id_gestion - 1 loop
            	--buscamos si existe la relacion de id_categoria_programatica para la siguiente gestion
               if exists (select 1
                          from pre.tunidad_ejecutora_ids tuei
                          where tuei.id_unidad_ejecutora_uno = v_registros.id_unidad_ejecutora) then


                          --encontramos el id_categoria_programatica de la gestion siguiente
                          select tuei.id_unidad_ejecutora_dos
                          into v_id_unidad_dos
                          from  pre.tunidad_ejecutora_ids tuei
                          where tuei.id_unidad_ejecutora_uno = v_registros.id_unidad_ejecutora;
                          --si no existe registrado la relacion de partidas con clases de gasto realizamos la insercion en la tabla
                          if not exists ( select 1
                                          from  sigep.tunidad_ejecutora tue
                                          where tue.id_ue = v_registros.id_ue and tue.id_da = v_registros.id_da
                                      	  and tue.ue = v_registros.ue and tue.desc_ue = v_registros.desc_ue
                                          and tue.id_unidad_ejecutora = v_id_unidad_dos ) then

                            insert into sigep.tunidad_ejecutora(
                            	id_usuario_reg,
                                id_usuario_mod,
                                fecha_reg,
                                fecha_mod,
                                estado_reg,
                                id_usuario_ai,
                                usuario_ai,

                                id_ue,
                                id_da,
                                ue,
                                desc_ue,
                                id_unidad_ejecutora,
                                id_gestion
                            )values(
                            	p_id_usuario,
                                null,
                                now(),
                                null,
                                'activo',
                                null,
                                null,

                                v_registros.id_ue,
                                v_registros.id_da,
                                v_registros.ue,
                                v_registros.desc_ue,
                                v_id_unidad_dos,
                                v_id_gestion
                            );
                          end if;
               end if;
            end loop;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fuente Financiamiento Clonados');
            v_resp = pxp.f_agrega_clave(v_resp,'gestion destino',v_id_gestion::varchar);

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