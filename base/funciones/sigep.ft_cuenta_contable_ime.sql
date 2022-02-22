CREATE OR REPLACE FUNCTION sigep.ft_cuenta_contable_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_cuenta_contable_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tcuenta_contable'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 16:53:56
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
	v_id_cuenta_contable	integer;

    v_cuenta_contable		record;
	v_id_cuenta 			integer;
    v_id_gestion			integer;
    v_contador_reg			integer;

BEGIN

    v_nombre_funcion = 'sigep.ft_cuenta_contable_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_CUE_CONT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:53:56
	***********************************/

	if(p_transaccion='SIGEP_CUE_CONT_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tcuenta_contable(
			des_cuenta_contable,
			cuenta_contable,
			imputable,
			id_cuenta,
			estado_reg,
			id_gestion,
			modelo_contable,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.des_cuenta_contable,
			v_parametros.cuenta_contable,
			v_parametros.imputable,
			v_parametros.id_cuenta,
			'activo',
			v_parametros.id_gestion,
			v_parametros.modelo_contable,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_cuenta_contable into v_id_cuenta_contable;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CuentaContable almacenado(a) con exito (id_cuenta_contable'||v_id_cuenta_contable||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_contable',v_id_cuenta_contable::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_CUE_CONT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:53:56
	***********************************/

	elsif(p_transaccion='SIGEP_CUE_CONT_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tcuenta_contable set
			des_cuenta_contable = v_parametros.des_cuenta_contable,
			cuenta_contable = v_parametros.cuenta_contable,
			imputable = v_parametros.imputable,
			id_cuenta = v_parametros.id_cuenta,
			id_gestion = v_parametros.id_gestion,
			modelo_contable = v_parametros.modelo_contable,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cuenta_contable=v_parametros.id_cuenta_contable;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CuentaContable modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_contable',v_parametros.id_cuenta_contable::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_CUE_CONT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:53:56
	***********************************/

	elsif(p_transaccion='SIGEP_CUE_CONT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tcuenta_contable
            where id_cuenta_contable=v_parametros.id_cuenta_contable;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CuentaContable eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_contable',v_parametros.id_cuenta_contable::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'SIGEP_CLONAR_CUE_CON'
 	#DESCRIPCION:	Clonar registros Cuenta Contable
 	#AUTOR:		franklin.espinoza
 	#FECHA:		10-01-2022 13:18:08
	***********************************/

	elsif(p_transaccion='SIGEP_CLONAR_CUE_CON')then

		begin

        	select count(cc.id_cuenta_contable)
            into v_contador_reg
            from sigep.tcuenta_contable cc
            where cc.id_gestion = v_parametros.id_gestion;

            if v_contador_reg > 0 then

              select ges.id_gestion
              into v_id_gestion
              from param.tgestion ges
              where ges.gestion = v_parametros.gestion+1;
              --Sentencia de la eliminacion
              for v_cuenta_contable in select cc.modelo_contable, cc.cuenta_contable, cc.des_cuenta_contable, cc.imputable, cc.id_cuenta, cc.id_gestion
              						   from sigep.tcuenta_contable cc
                                       where cc.id_gestion = v_parametros.id_gestion
                                       order by cc.cuenta_contable asc loop

                  select tcu.id_cuenta_dos
                  into v_id_cuenta
                  from conta.tcuenta_ids tcu
                  where tcu.id_cuenta_uno = v_cuenta_contable.id_cuenta;

                  --raise 'v_id_gestion %, %, %, %', v_id_gestion, v_id_partida, v_parametros.gestion, v_parametros.id_gestion;

                  insert into sigep.tcuenta_contable (
                      modelo_contable,
                      cuenta_contable,
                      des_cuenta_contable,
                      imputable,
                      id_cuenta,
                      id_gestion,
                      id_usuario_reg,
                      fecha_reg
                  ) values (
                      v_cuenta_contable.modelo_contable,
                      v_cuenta_contable.cuenta_contable,
                      v_cuenta_contable.des_cuenta_contable,
                      v_cuenta_contable.imputable,
                      v_id_cuenta,
                      v_id_gestion,
                      p_id_usuario,
                      now()
                  );

              end loop;

              --Definicion de la respuesta
              v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registros de Cuenta Contable clonados exitosamente de la gestión '||v_parametros.gestion::varchar||' a la gestión '||(v_parametros.gestion+1)::varchar)||'.';
              v_resp = pxp.f_agrega_clave(v_resp,'gestion',(v_parametros.gestion+1)::varchar);
            else
            	raise 'Estimado Funcionario, No existe registros en la gestion que pretende Clonar.';
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Error al clonar Cuenta Contable de la gestión '||v_parametros.gestion::varchar||' a la gestión '||(v_parametros.gestion+1)::varchar)||'.';
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

ALTER FUNCTION sigep.ft_cuenta_contable_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;