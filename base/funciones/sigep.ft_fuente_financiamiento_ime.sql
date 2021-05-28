CREATE OR REPLACE FUNCTION sigep.ft_fuente_financiamiento_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_fuente_financiamiento_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tfuente_financiamiento'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 15:54:19
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
	v_id_fuente_financiamiento	integer;

    v_id_gestion			integer;
    v_id_fuente_dos			integer;
    v_registros				record;

BEGIN

    v_nombre_funcion = 'sigep.ft_fuente_financiamiento_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_FUE_FIN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:19
	***********************************/

	if(p_transaccion='SIGEP_FUE_FIN_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tfuente_financiamiento(
			estado_reg,
			fuente,
			sigla_fuente,
			desc_fuente,
			id_fuente,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
            id_cp_fuente_fin,
            id_gestion
          	) values(
			'activo',
			v_parametros.fuente,
			v_parametros.sigla_fuente,
			v_parametros.desc_fuente,
			v_parametros.id_fuente,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.id_cp_fuente_fin,
			v_parametros.id_gestion

			)RETURNING id_fuente_financiamiento into v_id_fuente_financiamiento;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','FuenteFinanciamiento almacenado(a) con exito (id_fuente_financiamiento'||v_id_fuente_financiamiento||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fuente_financiamiento',v_id_fuente_financiamiento::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_FUE_FIN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:19
	***********************************/

	elsif(p_transaccion='SIGEP_FUE_FIN_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tfuente_financiamiento set
			fuente = v_parametros.fuente,
			sigla_fuente = v_parametros.sigla_fuente,
			desc_fuente = v_parametros.desc_fuente,
			id_fuente = v_parametros.id_fuente,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_cp_fuente_fin = v_parametros.id_cp_fuente_fin,
            id_gestion = v_parametros.id_gestion
			where id_fuente_financiamiento=v_parametros.id_fuente_financiamiento;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','FuenteFinanciamiento modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fuente_financiamiento',v_parametros.id_fuente_financiamiento::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_FUE_FIN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:54:19
	***********************************/

	elsif(p_transaccion='SIGEP_FUE_FIN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tfuente_financiamiento
            where id_fuente_financiamiento=v_parametros.id_fuente_financiamiento;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','FuenteFinanciamiento eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fuente_financiamiento',v_parametros.id_fuente_financiamiento::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'PRE_CLO_FUE_FIN_IME'
 	#DESCRIPCION:	Clonacion de Registros Fuente Financiamiento
 	#AUTOR:		franklin.espinoza
 	#FECHA:		18-01-2021 10:00:23
	***********************************/

	elsif(p_transaccion='PRE_CLO_FUE_FIN_IME')then

		begin

          select tg.id_gestion
          into v_id_gestion
          from param.tgestion tg
          where tg.gestion = date_part('year',current_date);

			for v_registros in select tff.id_fuente,
                                      tff.fuente,
                                      tff.desc_fuente,
                                      tff.sigla_fuente,
                                      tff.id_cp_fuente_fin
        						from sigep.tfuente_financiamiento tff
                                where tff.id_gestion = v_id_gestion - 1 loop
            	--buscamos si existe la relacion de id_categoria_programatica para la siguiente gestion
               if exists (select 1
                          from pre.tcp_fuente_fin_ids tffi
                          where tffi.id_cp_fuente_fin_uno = v_registros.id_cp_fuente_fin) then


                          --encontramos el id_categoria_programatica de la gestion siguiente
                          select tffi.id_cp_fuente_fin_dos
                          into v_id_fuente_dos
                          from  pre.tcp_fuente_fin_ids tffi
                          where tffi.id_cp_fuente_fin_uno = v_registros.id_cp_fuente_fin;
                          --si no existe registrado la relacion de partidas con clases de gasto realizamos la insercion en la tabla
                          if not exists ( select 1
                                          from  sigep.tfuente_financiamiento tff
                                          where tff.id_fuente = v_registros.id_fuente and tff.fuente = v_registros.fuente
                                      	  and tff.desc_fuente = v_registros.desc_fuente and tff.sigla_fuente = v_registros.sigla_fuente
                                          and tff.id_cp_fuente_fin = v_id_fuente_dos ) then

                            insert into sigep.tfuente_financiamiento(
                            	id_usuario_reg,
                                id_usuario_mod,
                                fecha_reg,
                                fecha_mod,
                                estado_reg,
                                id_usuario_ai,
                                usuario_ai,

                                id_fuente,
                                fuente,
                                desc_fuente,
                                sigla_fuente,
                                id_cp_fuente_fin,
                                id_gestion
                            )values(
                            	p_id_usuario,
                                null,
                                now(),
                                null,
                                'activo',
                                null,
                                null,

                                v_registros.id_fuente,
                                v_registros.fuente,
                                v_registros.desc_fuente,
                                v_registros.sigla_fuente,
                                v_id_fuente_dos,
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