CREATE OR REPLACE FUNCTION sigep.ft_cuenta_bancaria_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_cuenta_bancaria_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tcuenta_bancaria'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        08-09-2017 13:42:27
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
    v_id_cuenta_bancaria	integer;
    v_record                record;

    v_record_json			jsonb;
BEGIN

    v_nombre_funcion = 'sigep.ft_cuenta_bancaria_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'SIGEP_CUEN_BAN_INS'
     #DESCRIPCION:	Insercion de registros
     #AUTOR:		franklin.espinoza
     #FECHA:		08-09-2017 13:42:27
    ***********************************/

    if(p_transaccion='SIGEP_CUEN_BAN_INS')then

        begin
            --Sentencia de la insercion
            insert into sigep.tcuenta_bancaria(
                banco,
                cuenta,
                desc_cuenta,
                moneda,
                tipo_cuenta,
                estado_cuenta,
                id_cuenta_bancaria,
                estado_reg,

                id_usuario_ai,
                usuario_ai,
                fecha_reg,
                id_usuario_reg,

                id_usuario_mod,
                fecha_mod
            ) values(
                        v_parametros.banco,
                        v_parametros.cuenta,
                        v_parametros.desc_cuenta,
                        v_parametros.moneda,
                        v_parametros.tipo_cuenta,
                        v_parametros.estado_cuenta,
                        v_parametros.id_cuenta_bancaria,
                        'activo',
                        v_parametros._id_usuario_ai,
                        v_parametros._nombre_usuario_ai,
                        now(),
                        p_id_usuario,
                        null,
                        null


                    )RETURNING id_cuenta_bancaria_boa into v_id_cuenta_bancaria;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CuentaBancaria almacenado(a) con exito (id_cuenta_bancaria'||v_id_cuenta_bancaria||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria',v_id_cuenta_bancaria::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'SIGEP_CUEN_BAN_MOD'
         #DESCRIPCION:	Modificacion de registros
         #AUTOR:		franklin.espinoza
         #FECHA:		08-09-2017 13:42:27
        ***********************************/

    elsif(p_transaccion='SIGEP_CUEN_BAN_MOD')then

        begin
            --Sentencia de la modificacion
            update sigep.tcuenta_bancaria set

                                              desc_cuenta = v_parametros.desc_cuenta,
                                              moneda = v_parametros.moneda,
                                              cuenta = v_parametros.cuenta,
                                              tipo_cuenta = v_parametros.tipo_cuenta,
                                              estado_cuenta = v_parametros.estado_cuenta,
                                              banco = v_parametros.banco,
                                              id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
                                              id_usuario_mod = p_id_usuario,
                                              fecha_mod = now(),
                                              id_usuario_ai = v_parametros._id_usuario_ai,
                                              usuario_ai = v_parametros._nombre_usuario_ai
            where id_cuenta_bancaria_boa = v_parametros.id_cuenta_bancaria_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CuentaBancaria modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria_boa',v_parametros.id_cuenta_bancaria_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'SIGEP_CUEN_BAN_ELI'
         #DESCRIPCION:	Eliminacion de registros
         #AUTOR:		franklin.espinoza
         #FECHA:		08-09-2017 13:42:27
        ***********************************/

    elsif(p_transaccion='SIGEP_CUEN_BAN_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from sigep.tcuenta_bancaria
            where id_cuenta_bancaria_boa = v_parametros.id_cuenta_bancaria_boa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CuentaBancaria eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria_boa',v_parametros.id_cuenta_bancaria_boa::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'SIGEP_CUEN_BAN_SYNC'
         #DESCRIPCION:	Sincronizar Cuentas Bancarias
         #AUTOR:		franklin.espinoza
         #FECHA:		01-07-2022 13:42:27
        ***********************************/

    elsif(p_transaccion='SIGEP_CUEN_BAN_SYNC')then

        begin
            --Sentencia de la eliminacion
            /*for v_record in select tcb.banco, tcb.cuenta, tcb.desc_cuenta, tcb.moneda, tcb.tipo_cuenta, tcb.estado_cuenta
                            from sigep.tcuenta_bancaria tcb
                            where tcb.estado_reg = 'activo' loop

            end loop;*/

            for v_record_json in SELECT * FROM jsonb_array_elements( v_parametros.jsonData )  loop
                --raise 'v_record_json: %, %, %',v_record_json->>'banco',v_record_json->>'cuenta',v_record_json->>'moneda';

                select tcb.id_cuenta_bancaria
                into v_id_cuenta_bancaria
                from sigep.tcuenta_bancaria tcb
                where tcb.banco = (v_record_json->>'banco')::integer and tcb.cuenta = (v_record_json->>'cuenta')::varchar and tcb.moneda = (v_record_json->>'moneda')::integer;

                if v_id_cuenta_bancaria is null then
                    insert into sigep.tcuenta_bancaria(
                        banco,
                        cuenta,
                        desc_cuenta,
                        moneda,
                        tipo_cuenta,
                        estado_cuenta,
                        estado_reg,
                        fecha_reg,
                        id_usuario_reg,
                        id_usuario_mod,
                        fecha_mod
                    ) values(
                                (v_record_json->>'banco')::integer,
                                (v_record_json->>'cuenta')::varchar,
                                (v_record_json->>'descripcion')::varchar,
                                (v_record_json->>'moneda')::integer,
                                (v_record_json->>'tipoCuenta')::char,
                                coalesce((v_record_json->>'estadoCuenta')::char,'V'),
                                'activo',
                                now(),
                                p_id_usuario,
                                null,
                                null
                            );
                end if;
            end loop;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Bancaria Sincronizado Exitosamente.');
            v_resp = pxp.f_agrega_clave(v_resp,'estado','exito'::varchar);

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

ALTER FUNCTION sigep.ft_cuenta_bancaria_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;