CREATE OR REPLACE FUNCTION sigep.ft_objeto_gasto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_objeto_gasto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tobjeto_gasto'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 13:18:08
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
	v_id_objeto_gasto		integer;

    v_objeto_gasto			record;
	v_id_partida			integer;
    v_id_gestion			integer;
    v_contador_reg			integer;
BEGIN

    v_nombre_funcion = 'sigep.ft_objeto_gasto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_OBJ_GAS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 13:18:08
	***********************************/

	if(p_transaccion='SIGEP_OBJ_GAS_INS')then

        begin

        	--Sentencia de la insercion
        	insert into sigep.tobjeto_gasto(
			id_partida,
			id_gestion,
			desc_objeto,
			nivel,
			objeto,
			estado_reg,
			id_objeto,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_partida,
			v_parametros.id_gestion,
			v_parametros.desc_objeto,
			v_parametros.nivel,
			v_parametros.objeto,
			'activo',
			v_parametros.id_objeto,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_objeto_gasto into v_id_objeto_gasto;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetoGasto almacenado(a) con exito (id_objeto_gasto'||v_id_objeto_gasto||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objeto_gasto',v_id_objeto_gasto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_OBJ_GAS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 13:18:08
	***********************************/

	elsif(p_transaccion='SIGEP_OBJ_GAS_MOD')then

		begin
        	--raise exception 'v_parametros.id_gestion: %',v_parametros.id_gestion;
			--Sentencia de la modificacion
			update sigep.tobjeto_gasto set
			id_partida = v_parametros.id_partida,
			id_gestion = v_parametros.id_gestion,
			desc_objeto = v_parametros.desc_objeto,
			nivel = v_parametros.nivel,
			objeto = v_parametros.objeto,
			id_objeto = v_parametros.id_objeto,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_objeto_gasto=v_parametros.id_objeto_gasto;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetoGasto modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objeto_gasto',v_parametros.id_objeto_gasto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_OBJ_GAS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 13:18:08
	***********************************/

	elsif(p_transaccion='SIGEP_OBJ_GAS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tobjeto_gasto
            where id_objeto_gasto=v_parametros.id_objeto_gasto;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetoGasto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objeto_gasto',v_parametros.id_objeto_gasto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'SIGEP_CLONAR_OBJ_GAS'
 	#DESCRIPCION:	Clonar registros Objeto de Gasto
 	#AUTOR:		franklin.espinoza
 	#FECHA:		10-01-2022 13:18:08
	***********************************/

	elsif(p_transaccion='SIGEP_CLONAR_OBJ_GAS')then

		begin

        	select count(og.id_objeto_gasto)
            into v_contador_reg
            from sigep.tobjeto_gasto og
            where og.id_gestion = v_parametros.id_gestion;

            if v_contador_reg > 0 then
              select ges.id_gestion
              into v_id_gestion
              from param.tgestion ges
              where ges.gestion = v_parametros.gestion+1;
              --Sentencia de la eliminacion
              for v_objeto_gasto in select og.id_objeto, og.objeto, og.desc_objeto, og.nivel, og.id_partida, og.id_gestion, og.codigo_objeto
                                    from sigep.tobjeto_gasto og
                                    where og.id_gestion = v_parametros.id_gestion
                                    order by id_objeto asc loop

                  select tpa.id_partida_dos
                  into v_id_partida
                  from pre.tpartida_ids tpa
                  where tpa.id_partida_uno = v_objeto_gasto.id_partida;

                  --raise 'v_id_gestion %, %, %, %', v_id_gestion, v_id_partida, v_parametros.gestion, v_parametros.id_gestion;

                  insert into sigep.tobjeto_gasto (
                      id_objeto,
                      objeto,
                      desc_objeto,
                      nivel,
                      id_partida,
                      id_gestion,
                      codigo_objeto,
                      id_usuario_reg,
                      fecha_reg
                  ) values (
                      v_objeto_gasto.id_objeto,
                      v_objeto_gasto.objeto,
                      v_objeto_gasto.desc_objeto,
                      v_objeto_gasto.nivel,
                      v_id_partida,
                      v_id_gestion,
                      v_objeto_gasto.codigo_objeto,
                      p_id_usuario,
                      now()
                  );

              end loop;

              --Definicion de la respuesta
              v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registros de Objeto Gasto clonados exitosamente de la gestión '||v_parametros.gestion::varchar||' a la gestión '||(v_parametros.gestion+1)::varchar)||'.';
              v_resp = pxp.f_agrega_clave(v_resp,'gestion',(v_parametros.gestion+1)::varchar);
            else
            	raise 'Estimado Funcionario, No existe registros en la gestion que pretende Clonar.';
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Error al clonar Objeto Gasto de la gestión '||v_parametros.gestion::varchar||' a la gestión '||(v_parametros.gestion+1)::varchar)||'.';
            end if;

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

ALTER FUNCTION sigep.ft_objeto_gasto_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;