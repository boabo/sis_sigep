CREATE OR REPLACE FUNCTION sigep.ft_proyecto_actividad_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_proyecto_actividad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tproyecto_actividad'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        06-09-2017 21:27:18
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
	v_id_proyecto_actividad	integer;
    v_id_gestion			integer;
    v_id_categoria_dos		integer;

    v_registros				record;
    v_proyecto_actividad	record;
    v_id_categoria_uno		integer;

    v_contador_reg			integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_proyecto_actividad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ACT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:18
	***********************************/

	if(p_transaccion='SIGEP_PRO_ACT_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tproyecto_actividad(
			id_programa,
			desc_catprg,
			id_catprg,
			id_categoria_programatica,
			programa,
			id_entidad,
			proyecto,
			nivel,
			estado_reg,
			actividad,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_programa,
			v_parametros.desc_catprg,
			v_parametros.id_catprg,
			v_parametros.id_categoria_programatica,
			v_parametros.programa,
			v_parametros.id_entidad,
			v_parametros.proyecto,
			v_parametros.nivel,
			'activo',
			v_parametros.actividad,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_proyecto_actividad into v_id_proyecto_actividad;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ProyectoActividad almacenado(a) con exito (id_proyecto_actividad'||v_id_proyecto_actividad||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_actividad',v_id_proyecto_actividad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ACT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:18
	***********************************/

	elsif(p_transaccion='SIGEP_PRO_ACT_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tproyecto_actividad set
			id_programa = v_parametros.id_programa,
			desc_catprg = v_parametros.desc_catprg,
			id_catprg = v_parametros.id_catprg,
			id_categoria_programatica = v_parametros.id_categoria_programatica,
			programa = v_parametros.programa,
			id_entidad = v_parametros.id_entidad,
			proyecto = v_parametros.proyecto,
			nivel = v_parametros.nivel,
			actividad = v_parametros.actividad,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_proyecto_actividad=v_parametros.id_proyecto_actividad;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ProyectoActividad modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_actividad',v_parametros.id_proyecto_actividad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_PRO_ACT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		06-09-2017 21:27:18
	***********************************/

	elsif(p_transaccion='SIGEP_PRO_ACT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tproyecto_actividad
            where id_proyecto_actividad=v_parametros.id_proyecto_actividad;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ProyectoActividad eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_actividad',v_parametros.id_proyecto_actividad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'PRE_CLO_PRO_ACT_IME'
 	#DESCRIPCION:	Clonacion de Registros Proyecto Actividad
 	#AUTOR:		franklin.espinoza
 	#FECHA:		18-01-2021 10:00:23
	***********************************/

	elsif(p_transaccion='PRE_CLO_PRO_ACT_IME')then

		begin

          select tg.id_gestion
          into v_id_gestion
          from param.tgestion tg
          where tg.gestion = date_part('year',current_date);

			for v_registros in select tpa.id_catprg,
             						  tpa.id_entidad,
                                      tpa.programa,
                                      tpa.proyecto,
                                      tpa.actividad,
                                      tpa.desc_catprg,
                                      tpa.nivel,
                                      tpa.id_programa,
                                      tpa.id_categoria_programatica
        						from sigep.tproyecto_actividad tpa
                                where tpa.id_gestion = v_id_gestion - 1 loop
            	--buscamos si existe la relacion de id_categoria_programatica para la siguiente gestion
               if exists (select 1
                          from pre.tcategoria_programatica_ids tcp
                          where tcp.id_categoria_programatica_uno = v_registros.id_categoria_programatica) then


                          --encontramos el id_categoria_programatica de la gestion siguiente
                          select tcp.id_categoria_programatica_dos
                          into v_id_categoria_dos
                          from  pre.tcategoria_programatica_ids tcp
                          where tcp.id_categoria_programatica_uno = v_registros.id_categoria_programatica;
                          --si no existe registrado la relacion de partidas con clases de gasto realizamos la insercion en la tabla
                          if not exists ( select 1
                                          from  sigep.tproyecto_actividad tpa
                                          where tpa.id_catprg = v_registros.id_catprg and tpa.id_entidad = v_registros.id_entidad and tpa.programa = v_registros.programa
                                      	  and tpa.proyecto = v_registros.proyecto and tpa.actividad = v_registros.actividad  and tpa.desc_catprg = v_registros.desc_catprg
                                      	  and tpa.nivel = v_registros.nivel and tpa.id_programa = v_registros.id_programa
                                          and tpa.id_categoria_programatica = v_id_categoria_dos ) then

                            insert into sigep.tproyecto_actividad(
                            	id_usuario_reg,
                                id_usuario_mod,
                                fecha_reg,
                                fecha_mod,
                                estado_reg,
                                id_usuario_ai,
                                usuario_ai,

                                id_catprg,
                                id_entidad,
                                programa,
                                proyecto,
                                actividad,
                                desc_catprg,
                                nivel,
                                id_programa,
                                id_categoria_programatica,
                                id_gestion
                            )values(
                            	p_id_usuario,
                                null,
                                now(),
                                null,
                                'activo',
                                null,
                                null,

                                v_registros.id_catprg,
                                v_registros.id_entidad,
                                v_registros.programa,
                                v_registros.proyecto,
                                v_registros.actividad,
                                v_registros.desc_catprg,
                                v_registros.nivel,
                                v_registros.id_programa,
                                v_id_categoria_dos,
                                v_id_gestion
                            );
                          end if;
               end if;
            end loop;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proyecto Actividad Clonados');
            v_resp = pxp.f_agrega_clave(v_resp,'gestion destino',v_id_gestion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'SIGEP_CLONAR_PRO_ACT'
 	#DESCRIPCION:	Clonar registros Objeto de Gasto
 	#AUTOR:		franklin.espinoza
 	#FECHA:		10-01-2022 13:18:08
	***********************************/

	elsif(p_transaccion='SIGEP_CLONAR_PRO_ACT')then

		begin

        	select count(pa.id_proyecto_actividad)
            into v_contador_reg
            from sigep.tproyecto_actividad pa
            where pa.id_gestion = v_parametros.id_gestion;

            if v_contador_reg > 0 then

              select ges.id_gestion
              into v_id_gestion
              from param.tgestion ges
              where ges.gestion = v_parametros.gestion+1;
              --Sentencia de la eliminacion
              for v_proyecto_actividad in select pa.id_catprg, pa.id_entidad, pa.programa, pa.proyecto, pa.actividad, pa.desc_catprg, pa.nivel, pa.id_programa, pa.id_categoria_programatica
                                    from sigep.tproyecto_actividad pa
                                    where pa.id_gestion = v_parametros.id_gestion
                                    order by pa.programa asc loop

                  select tcp.id_categoria_programatica_dos
                  into v_id_categoria_dos
                  from pre.tcategoria_programatica_ids tcp
                  where tcp.id_categoria_programatica_uno = v_proyecto_actividad.id_categoria_programatica;

                  --raise 'v_id_gestion %, %, %, %', v_id_gestion, v_id_partida, v_parametros.gestion, v_parametros.id_gestion;

                  insert into sigep.tproyecto_actividad (
                      id_catprg,
                      id_entidad,
                      programa,
                      proyecto,
                      actividad,
                      desc_catprg,
                      nivel,
                      id_programa,

                      id_categoria_programatica,
                      id_gestion,
                      id_usuario_reg,
                      fecha_reg
                  ) values (
                      v_proyecto_actividad.id_catprg,
                      v_proyecto_actividad.id_entidad,
                      v_proyecto_actividad.programa,
                      v_proyecto_actividad.proyecto,
                      v_proyecto_actividad.actividad,
                      v_proyecto_actividad.desc_catprg,
                      v_proyecto_actividad.nivel,
                      v_proyecto_actividad.id_programa,

					  v_id_categoria_dos,
					  v_id_gestion,
                      p_id_usuario,
                      now()
                  );

              end loop;

              --Definicion de la respuesta
              v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registros de Proyecto Actividad clonados exitosamente de la gestión '||v_parametros.gestion::varchar||' a la gestión '||(v_parametros.gestion+1)::varchar)||'.';
              v_resp = pxp.f_agrega_clave(v_resp,'gestion',(v_parametros.gestion+1)::varchar);
            else
            	raise 'Estimado Funcionario, No existe registros en la gestion que pretende Clonar.';
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Error al clonar Proyecto Actividad de la gestión '||v_parametros.gestion::varchar||' a la gestión '||(v_parametros.gestion+1)::varchar)||'.';
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

ALTER FUNCTION sigep.ft_proyecto_actividad_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;