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
    v_valores_input     	varchar[];
    v_consulta    			record;
    v_preve					record;
    v_colnames				text[];
    v_colcom				text[];
    v_coldev				text[];
    v_matriz				varchar[];

	v_record				record;
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
 	#TRANSACCION:  'SIGEP_RESP'
 	#DESCRIPCION:	Registra la Consulta de Beneficiarios del Sigep
 	#AUTOR:		rzabala
 	#FECHA:		06-07-2019 15:10:26
	***********************************/

	elsif(p_transaccion='SIGEP_RESP')then

		begin
			--Sentencia de la consulta
			--raise exception 'checkpoint REGISTRO BENEFICIARIO SIGEP: %', v_parametros.id_beneficiario;

           update sigep.tsigep_adq
           set 	estado = 'finalizado',
           		nro_preventivo = v_parametros.nro_preventivo::int4,
           		nro_comprometido = v_parametros.nro_comprometido::int4,
           	   	nro_devengado = v_parametros.nro_devengado::int4
           where id_sigep_adq = v_parametros.id_sigep_adq;

           select ad.nro_doc_rdo, sad.momento
           into v_preve
           from sigep.tsigep_adq_det ad
           inner join sigep.tsigep_adq sad on sad.id_sigep_adq = ad.id_sigep_adq
           where ad.id_sigep_adq = v_parametros.id_sigep_adq;

           	for v_record in select ten.id_entrega, ten.c31 c31_ent, ten.fecha_c31 fecha_ent, tic.id_int_comprobante
                           from conta.tentrega ten
                           inner join conta.tentrega_det ted on ted.id_entrega = ten.id_entrega
                           inner join conta.tint_comprobante tic on tic.id_int_comprobante = ted.id_int_comprobante
                           where ten.id_entrega = v_preve.nro_doc_rdo::integer loop

                if v_parametros.nro_preventivo != '' or v_parametros.nro_devengado != '' then
                  update conta.tint_comprobante  set
                  	c31 = case
            			   when v_preve.momento = 'SIN_IMPUTACION' THEN upper(concat('SIP ',v_parametros.nro_devengado))
                           when v_preve.momento = 'REGULARIZAS' THEN upper(concat('REG. SIP ',v_parametros.nro_devengado))
                           when v_preve.momento = 'REGULARIZAC' THEN upper(concat('REG. CIP ',v_parametros.nro_preventivo))
                           when v_preve.momento = 'REGULARIZAC_REV' THEN upper(concat('REV. CIP ',v_parametros.nro_preventivo))
                           when v_preve.momento = 'REGULARIZAS_REV' THEN upper(concat('REV. SIP ',v_parametros.nro_devengado))
            		  	   ELSE upper(concat('CIP ',v_parametros.nro_preventivo))
            		  	end
                  	--,fecha_c31 = v_record.fecha_ent
                  where id_int_comprobante = v_record.id_int_comprobante;
        		end if;

    		end loop;

           /*update conta.tint_comprobante
           	set c31 = case
            			   when v_preve.momento = 'SIN_IMPUTACION' THEN upper(concat('SIP ',v_parametros.nro_devengado))
                           when v_preve.momento = 'REGULARIZAS' THEN upper(concat('REG. SIP ',v_parametros.nro_devengado))
                           when v_preve.momento = 'REGULARIZAC' THEN upper(concat('REG. CIP ',v_parametros.nro_preventivo))
                           when v_preve.momento = 'REGULARIZAC_REV' THEN upper(concat('REG. CIP ',v_parametros.nro_preventivo))
                           when v_preve.momento = 'REGULARIZAS_REV' THEN upper(concat('REG. CIP ',v_parametros.nro_devengado))
            		  	   ELSE upper(concat('CIP ',v_parametros.nro_preventivo))
            		  end
            where id_int_comprobante = v_preve.nro_doc_rdo;*/


			--Definicion de la respuesta
            --v_consulta:=v_consulta||v_parametros.filtro;
            --raise exception 'checkpoint CONSULTA BENEFICIARIO SIGEP: %',v_consulta;
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep registro beneficiario exitoso(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'nro_preventivo',v_parametros.nro_preventivo::varchar);
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

           update param.tproveedor r set
           id_beneficiario = v_parametros.id_beneficiario::int4,
           razon_social_sigep =  v_parametros.razon_social_sigep
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
 	#TRANSACCION:  'SIGEP_RESULT'
 	#DESCRIPCION:	Consulta mostrar mensajes de Respuesta del Sigep
 	#AUTOR:		rzabala
 	#FECHA:		14-08-2019 18:00:26
	***********************************/

	elsif(p_transaccion='SIGEP_RESULT')then

		begin
			--Sentencia de la consulta
            --v_valores_input = string_to_array('419,420', ',');
            v_valores_input = string_to_array(v_parametros.ids, ',');
            	--raise exception 'checkpoint REGISTRO RESULTADO SIGEP: %', v_parametros.ids;
            FOR i IN 1.. array_upper(v_valores_input, 1)
			LOOP
            --raise exception 'checkpoint REGISTRO RESULTADO SIGEP: %', v_valores_input[i];
            v_colnames[i]:= (SELECT sig.nro_preventivo--, sig.nro_comprometido, sig.nro_devengado
              FROM sigep.tsigep_adq sig
              inner join segu.tusuario usu1 on usu1.id_usuario = sig.id_usuario_reg
              left join segu.tusuario usu2 on usu2.id_usuario = sig.id_usuario_mod
              WHERE sig.id_sigep_adq =v_valores_input[i]::int4);
               v_colcom[i]:= (SELECT sig.nro_comprometido--, sig.nro_devengado
              FROM sigep.tsigep_adq sig
              inner join segu.tusuario usu1 on usu1.id_usuario = sig.id_usuario_reg
              left join segu.tusuario usu2 on usu2.id_usuario = sig.id_usuario_mod
              WHERE sig.id_sigep_adq =v_valores_input[i]::int4);
              v_coldev[i]:= (SELECT sig.nro_devengado
              FROM sigep.tsigep_adq sig
              inner join segu.tusuario usu1 on usu1.id_usuario = sig.id_usuario_reg
              left join segu.tusuario usu2 on usu2.id_usuario = sig.id_usuario_mod
              WHERE sig.id_sigep_adq =v_valores_input[i]::int4);
            	v_matriz[i]:=concat('Nro. Preventivo: ',v_colnames[i],' ||Nro. Compromiso: ', v_colcom[i],' ||Nro. Devengado: ', v_coldev[i]);

            end loop;
            --raise exception 'checkpoint REGISTRO RESULTADO SIGEP: %', v_matriz;

			--Definicion de la respuesta

            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sigep registro beneficiario exitoso(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'matriz_result',v_matriz::varchar);

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
COST 100;