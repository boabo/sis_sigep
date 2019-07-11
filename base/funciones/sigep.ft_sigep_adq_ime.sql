CREATE OR REPLACE FUNCTION sigep.ft_sigep_adq_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_sigep_adq_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tsigep_adq'
 AUTOR: 		 (rzabala)
 FECHA:	        15-03-2019 21:10:26
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-03-2019 21:10:26								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'sigep.tsigep_adq'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_sigep_adq			integer;
    v_consulta    			record;
    v_preve					record;

BEGIN

    v_nombre_funcion = 'sigep.ft_sigep_adq_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_SADQ_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rzabala
 	#FECHA:		15-03-2019 21:10:26
	***********************************/

	if(p_transaccion='SIGEP_SADQ_INS')then

        begin
        	--Sentencia de la insercion
        	insert into sigep.tsigep_adq(
			estado_reg,
			num_tramite,
			estado,
			momento,
			ultimo_mensaje,
			clase_gasto,
            id_service_request,
            nro_preventivo,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.num_tramite,
			v_parametros.estado,
			v_parametros.momento,
			v_parametros.ultimo_mensaje,
			v_parametros.clase_gasto,
            v_parametros.id_service_request,
            v_parametros.nro_preventivo,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_sigep_adq into v_id_sigep_adq;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep Adquisiciones almacenado(a) con exito (id_sigep_adq'||v_id_sigep_adq||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq',v_id_sigep_adq::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
         /*********************************
 	#TRANSACCION:  'SIGEP_REG_PREVE'
 	#DESCRIPCION:	Registra la Consulta de Beneficiarios del Sigep
 	#AUTOR:		rzabala
 	#FECHA:		12-06-2019 15:10:26
	***********************************/

	elsif(p_transaccion='SIGEP_REG_PREVE')then

		begin
			--Sentencia de la consulta
			--raise exception 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_parametros.id_beneficiario;

           update sigep.tsigep_adq
           set nro_preventivo = v_parametros.nro_preventivo::int4
           where id_sigep_adq = v_parametros.id_sigep_adq;

			--Definicion de la respuesta
            --v_consulta:=v_consulta||v_parametros.filtro;
            --raise exception 'checkpoint CONSULTA BENEFICIARIO SIGEP: %',v_consulta;
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep registro beneficiario exitoso(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'nro_preventivo',v_parametros.nro_preventivo::varchar);

            --Devuelve la respuesta
            --raise notice 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_resp;
            return v_resp;

		end;
	/*********************************
 	#TRANSACCION:  'SIGEP_COMPRODEVEN'
 	#DESCRIPCION:	Registra la Consulta de Beneficiarios del Sigep
 	#AUTOR:		rzabala
 	#FECHA:		06-07-2019 15:10:26
	***********************************/

	elsif(p_transaccion='SIGEP_COMPRODEVEN')then

		begin
			--Sentencia de la consulta
			--raise exception 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_parametros.id_beneficiario;

           update sigep.tsigep_adq
           set nro_comprometido = v_parametros.nro_comprometido::int4,
           	   nro_devengado = v_parametros.nro_devengado::int4
           where id_sigep_adq = v_parametros.id_sigep_adq;

           select ad.nro_preventivo
           into v_preve
           from sigep.tsigep_adq ad
           where ad.id_sigep_adq = v_parametros.id_sigep_adq;

			--Definicion de la respuesta
            --v_consulta:=v_consulta||v_parametros.filtro;
            --raise exception 'checkpoint CONSULTA BENEFICIARIO SIGEP: %',v_consulta;
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep registro beneficiario exitoso(a)');
            --v_resp = pxp.f_agrega_clave(v_resp,'nro_preventivo',v_preve::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'nro_comprometido',v_parametros.nro_comprometido::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'nro_devengado',v_parametros.nro_devengado::varchar);

            --Devuelve la respuesta
            --raise notice 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_resp;
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'SIGEP_REG_BENEF'
 	#DESCRIPCION:	Registra la Consulta de Beneficiarios del Sigep
 	#AUTOR:		rzabala
 	#FECHA:		05-06-2019 16:10:26
	***********************************/

	elsif(p_transaccion='SIGEP_REG_BENEF')then

		begin
			--Sentencia de la consulta
			--raise exception 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_parametros.id_beneficiario;

           update param.tproveedor
           set id_beneficiario = v_parametros.id_beneficiario::int4
           where id_proveedor=v_parametros.id_proveedor;

			--Definicion de la respuesta
            --v_consulta:=v_consulta||v_parametros.filtro;
            --raise exception 'checkpoint CONSULTA BENEFICIARIO SIGEP: %',v_consulta;
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep registro beneficiario exitoso(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proveedor',v_parametros.id_proveedor::varchar);

            --Devuelve la respuesta
            --raise notice 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_resp;
            return v_resp;

		end;
 /*********************************
 	#TRANSACCION:  'SIGEP_PREVE'
 	#DESCRIPCION:	Registra la Consulta de etapa Preventivo del Sigep
 	#AUTOR:		rzabala
 	#FECHA:		12-06-2019 09:42:26
	***********************************/

	elsif(p_transaccion='SIGEP_PREVE')then

		begin
			--Sentencia de la consulta
			--raise exception 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_parametros.id_proveedor;
            select (ARRAY(
            SELECT 	  sdet.id_sigep_adq,
                      sdet.clase_gasto_cip,
                      sdet.fecha_elaboracion,
                      sdet.gestion,
                      sdet.id_ptogto,
                      sdet.justificacion,
                      sdet.moneda,
                      sdet.monto_partida,
                      sdet.nro_doc_rdo,
                      sdet.sec_doc_rdo,
                      sdet.tipo_doc_rdo,
                      sdet.total_autorizado_mo,
                      usu1.cuenta,
                      sig.clase_gasto,
                      sig.momento,
                      sdet.id_fuente,
                      sdet.id_organismo,
                      sdet.beneficiario,
                      sdet.banco_benef,
                      sdet.cuenta_benef,
                      sdet.banco_origen,
                      sdet.cta_origen,
                      sdet.libreta_origen,
                      sig.nro_preventivo,
                      sdet.usuario_apro
                      --INTO v_preve
              FROM sigep.tsigep_adq_det sdet
              inner join segu.tusuario usu1 on usu1.id_usuario = sdet.id_usuario_reg
              left join segu.tusuario usu2 on usu2.id_usuario = sdet.id_usuario_mod
              inner join sigep.tsigep_adq sig on sig.id_sigep_adq = sdet.id_sigep_adq
              WHERE sdet.id_sigep_adq =v_parametros.id_sigep_adq))into v_preve;

              --v_preve = string_to_array(v_preve, ',');

               raise exception 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_preve;

                    UPDATE  sigep.tsigep_adq
					SET estado = 'registrado'
					WHERE id_sigep_adq =v_parametros.id_sigep_adq;


			--Definicion de la respuesta
            --raise exception 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_preve;
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep registro beneficiario exitoso(a)');
             FOR i IN 1.. array_upper(v_preve, 1)
				LOOP
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq',v_preve[i]::varchar[]);
            END loop;
            /*v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep registro beneficiario exitoso(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq',v_preve.id_sigep_adq::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'clase_gasto_cip',v_preve.clase_gasto_cip::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'fecha_elaboracion',v_preve.fecha_elaboracion::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'gestion',v_preve.gestion::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_ptogto',v_preve.id_ptogto::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'justificacion',v_preve.justificacion::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'moneda',v_preve.moneda::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'monto_partida',v_preve.monto_partida::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'nro_doc_rdo',v_preve.nro_doc_rdo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'sec_doc_rdo',v_preve.sec_doc_rdo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'tipo_doc_rdo',v_preve.tipo_doc_rdo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'total_autorizado_mo',v_preve.total_autorizado_mo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'usr_reg',v_preve.usr_reg::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'clase_gasto',v_preve.clase_gasto::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'momento',v_preve.momento::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_fuente',v_preve.id_fuente::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_organismo',v_preve.id_organismo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'beneficiario',v_preve.beneficiario::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'banco_benef',v_preve.banco_benef::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'cuenta_benef',v_preve.cuenta_benef::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'banco_origen',v_preve.banco_origen::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'cta_origen',v_preve.cta_origen::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'libreta_origen',v_preve.libreta_origen::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'nro_preventivo',v_preve.nro_preventivo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'usuario_apro',v_preve.usuario_apro::varchar);*/

            --Devuelve la respuesta
            --raise notice 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_resp;
            return v_resp;

		end;


 /*********************************
 	#TRANSACCION:  'SIGEP_BENEF'
 	#DESCRIPCION:	Registra la Consulta de Beneficiarios del Sigep
 	#AUTOR:		rzabala
 	#FECHA:		05-06-2019 16:10:26
	***********************************/

	elsif(p_transaccion='SIGEP_BENEF')then

		begin
			--Sentencia de la consulta
			--raise exception 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_parametros.id_proveedor;

           select
                provee.id_proveedor,
                provee.id_institucion,
                provee.id_persona,
                provee.tipo,
                provee.codigo,
                provee.nit,
                person.ci,
                instit.nombre as proveedor,
                person.nombre,
                person.ap_paterno,
                person.ap_materno,
                person.fecha_nacimiento,
                provee.id_beneficiario
                INTO
                v_consulta
                from param.tproveedor provee
                inner join segu.tusuario usu1 on usu1.id_usuario = provee.id_usuario_reg
                left join segu.tusuario usu2 on usu2.id_usuario = provee.id_usuario_mod
                left join segu.vpersona2 person on person.id_persona=provee.id_persona
                left join param.tinstitucion instit on instit.id_institucion=provee.id_institucion
                left join param.tlugar lug on lug.id_lugar = provee.id_lugar
                where  provee.id_proveedor = v_parametros.id_proveedor;

			--Definicion de la respuesta
            --v_consulta:=v_consulta||v_parametros.filtro;
            --raise exception 'checkpoint CONSULTA BENEFICIARIO SIGEP: %',v_consulta;
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep registro beneficiario exitoso(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proveedor',v_consulta.id_proveedor::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_institucion',v_consulta.id_institucion::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_persona',v_consulta.id_persona::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'tipo',v_consulta.tipo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo',v_consulta.codigo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'nit',v_consulta.nit::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'ci',v_consulta.ci::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'proveedor',v_consulta.proveedor::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'nombre',v_consulta.nombre::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'ap_paterno',v_consulta.ap_paterno::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'ap_materno',v_consulta.ap_materno::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'fecha_nacimiento',v_consulta.fecha_nacimiento::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_beneficiario',v_consulta.id_beneficiario::varchar);

            --Devuelve la respuesta
            raise notice 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_resp;
            return v_resp;

		end;


	/*********************************
 	#TRANSACCION:  'SIGEP_SADQ_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rzabala
 	#FECHA:		15-03-2019 21:10:26
	***********************************/

	elsif(p_transaccion='SIGEP_SADQ_MOD')then

		begin
			--Sentencia de la modificacion
			update sigep.tsigep_adq set
			num_tramite = v_parametros.num_tramite,
			estado = v_parametros.estado,
			momento = v_parametros.momento,
			ultimo_mensaje = v_parametros.ultimo_mensaje,
			clase_gasto = v_parametros.clase_gasto,
            id_service_request = v_parametros.id_service_request,
            nro_preventivo = v_parametros.nro_preventivo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_sigep_adq=v_parametros.id_sigep_adq;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep Adquisiciones modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq',v_parametros.id_sigep_adq::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_SADQ_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rzabala
 	#FECHA:		15-03-2019 21:10:26
	***********************************/

	elsif(p_transaccion='SIGEP_SADQ_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from sigep.tsigep_adq
            where id_sigep_adq=v_parametros.id_sigep_adq;

            delete from sigep.tsigep_adq_det
            where id_sigep_adq=v_parametros.id_sigep_adq;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep Adquisiciones eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_sigep_adq',v_parametros.id_sigep_adq::varchar);

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
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION sigep.ft_sigep_adq_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;