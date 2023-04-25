<?php
/**
 *@package  BoA
 *@file     MODSigepActionC21.php
 *@author  (franklin.espinoza)
 *@date    18-01-2022 11:10:26
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecuciostatusC21 de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */
include_once(dirname(__FILE__).'/../rest/PxpRestSigep.php');
//include_once(dirname(__FILE__).'/../../lib/rest/PxpRestSigep.php');
// __DIR__.'/../rest/PxpRestClient2.php';

class MODSigepActionC21 extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarSigepAdq(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='sigep.ft_sigep_adq_sel';
        $this->transaccion='SIGEP_SADQ_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(true);

        //$this->setParametro('nro_preventivo','nro_preventivo','int4');
        //$this->setParametro('sigep_adq','sigep_adq','varchar');
        //Definicion de la lista del resultado del query
        $this->captura('id_sigep_adq','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('num_tramite','varchar');
        $this->captura('estado','varchar');
        $this->captura('momento','varchar');
        $this->captura('ultimo_mensaje','varchar');
        $this->captura('clase_gasto','varchar');
        $this->captura('id_service_request','varchar');
        $this->captura('nro_preventivo','int4');
        $this->captura('nro_comprometido','int4');
        $this->captura('nro_devengado','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta(); //echo $this->consulta;exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump('respuesta consult:', $this->ejecutarConsulta());
        return $this->respuesta;
    }

    function consultaMonSigep(){

        $this->procedimiento='sigep.ft_sigep_adq_sel';
        $this->transaccion='SIGEP_CONS';
        $this->tipo_procedimiento='SEL';
        $this->count=false;

        //Define los parametros para la funcion
        $this->setParametro('id_sigep_adq','id_sigep_adq','int4');

        $this->captura('id_sigep_adq','int4');
        $this->captura('gestion','int4');
        $this->captura('clase_gasto_cip','int4');
        $this->captura('moneda','int4');
        $this->captura('total_autorizado_mo','numeric');
        $this->captura('id_ptogto','int4');
        $this->captura('monto_partida','numeric');
        $this->captura('nro_doc_rdo','int4');
        $this->captura('sec_doc_rdo','int4');
        $this->captura('tipo_doc_rdo','int4');
        $this->captura('fecha_elaboracion','date');
        $this->captura('justificacion','varchar');
        $this->captura('id_fuente','varchar');
        $this->captura('id_organismo','varchar');
        $this->captura('cuenta','varchar');
        $this->captura('beneficiario','varchar');
        $this->captura('banco_benef','varchar');
        $this->captura('cuenta_benef','varchar');
        $this->captura('banco_origen','varchar');
        $this->captura('cta_origen','varchar');
        $this->captura('libreta_origen','varchar');
        $this->captura('usuario_apro','varchar');
        $this->captura('clase_gasto','varchar');
        $this->captura('momento','varchar');
        $this->captura('nro_preventivo','int4');
        $this->captura('nro_comprometido','int4');
        $this->captura('nro_devengado','int4');
        $this->captura('monto_benef','numeric');
        $this->captura('liquido_pagable','numeric');
        $this->captura('multaMo','numeric');
        $this->captura('retencionMo','numeric');
        $this->captura('cuenta_contable','varchar');
        $this->captura('sisin','varchar');
        $this->captura('otfin','varchar');
        $this->captura('usuario_firm','varchar');

        $this->captura('cod_multa','varchar');
        $this->captura('cod_retencion','varchar');
        $this->captura('total_retencion','numeric');
        $this->captura('mes_rdo','int4');
        $this->captura('tipo_rdo','varchar');
        $this->captura('tipo_contrato','varchar');
        $this->captura('fecha_tipo_cambio','date');
        $this->captura('preventivo_sigep','integer');
        $this->captura('beneficiarios','jsonb');


        $this->armarConsulta();//var_dump($this->consulta);exit;
        $this->ejecutarConsulta();

        //var_dump('consulta preventivo:',$this->respuesta);
        return $this->respuesta;
    }

    /************************************************** C21 **************************************************/
    function getParametrosC21(){

        $this->procedimiento='sigep.ft_sigep_action_sel';
        $this->transaccion='C21_GET_PARAMS';
        $this->tipo_procedimiento='SEL';
        $this->count=false;

        //Define los parametros para la funcion
        $this->setParametro('id_sigep_adq','id_sigep_adq','int4');

        $this->captura('id_sigep_adq','int4');
        $this->captura('gestion','int4');
        $this->captura('clase_gasto_cip','int4');
        $this->captura('moneda','int4');
        $this->captura('total_autorizado_mo','numeric');
        $this->captura('id_ptorec','int4');
        $this->captura('monto_partida','numeric');
        $this->captura('nro_doc_rdo','int4');
        $this->captura('sec_doc_rdo','int4');
        $this->captura('tipo_doc_rdo','int4');
        $this->captura('fecha_elaboracion','date');
        $this->captura('justificacion','varchar');
        $this->captura('id_fuente','varchar');
        $this->captura('id_organismo','varchar');
        $this->captura('cuenta','varchar');
        $this->captura('beneficiario','varchar');
        $this->captura('banco_benef','varchar');
        $this->captura('cuenta_benef','varchar');
        $this->captura('banco_origen','varchar');
        $this->captura('cta_origen','varchar');
        $this->captura('libreta_origen','varchar');
        $this->captura('usuario_apro','varchar');
        $this->captura('clase_gasto','varchar');
        $this->captura('momento','varchar');
        $this->captura('nro_preventivo','int4');
        $this->captura('nro_comprometido','int4');
        $this->captura('nro_devengado','int4');
        $this->captura('monto_benef','numeric');
        $this->captura('liquido_pagable','numeric');
        $this->captura('multaMo','numeric');
        $this->captura('retencionMo','numeric');
        $this->captura('cuenta_contable','varchar');
        $this->captura('sisin','varchar');
        $this->captura('otfin','varchar');
        $this->captura('usuario_firm','varchar');

        $this->captura('cod_multa','varchar');
        $this->captura('cod_retencion','varchar');
        $this->captura('total_retencion','numeric');
        $this->captura('mes_rdo','int4');
        $this->captura('tipo_rdo','varchar');
        $this->captura('tipo_contrato','varchar');
        $this->captura('fecha_tipo_cambio','date');
        $this->captura('preventivo_sigep','integer');

        $this->captura('id_rubro','integer');
        $this->captura('id_ent_otorgante','integer');


        $this->armarConsulta();//var_dump($this->consulta);exit;
        $this->ejecutarConsulta();

        //var_dump('consulta preventivo:',$this->respuesta);
        return $this->respuesta;
    }

    function registrarServicesC21(){

        $list = $this->objParam->getParametro('list');
        $service_code = $this->objParam->getParametro ('service_code');
        $estado_c21 = $this->objParam->getParametro ('estado_c21');

        if ( $service_code == 'REG_CON_FLUJO_C21' || $service_code == 'REG_CMF_REV_C21') {
            $service = json_decode($list, true);
            foreach ($service as $servicio) {
                $fecha_new = str_replace('-', '/', $servicio["fecha_elaboracion"]);
                $fecha_elaboracion = date("d/m/Y", strtotime($fecha_new));
                $fecha_tipo_cambio = DateTime::createFromFormat('Y-m-d', $servicio["fecha_tipo_cambio"])->format('d/m/Y');

                $momento = $servicio["momento"];
                $id_adq = $servicio["id_sigep_adq"];

                $usuario = $servicio["cuenta"];
                $gestion = $servicio["gestion"];
                $resumen = $servicio["justificacion"];
                $moneda = $servicio["moneda"];
                $total_autorizado = $servicio["total_autorizado_mo"];
                $liquido_pagable = $servicio["liquido_pagable"];

                $tipo_doc_rdo = $servicio["tipo_doc_rdo"];
                $nro_doc_rdo = $servicio["nro_doc_rdo"];
                $sec_doc_rdo = $servicio["sec_doc_rdo"];

                $otfin = $servicio["otfin"];

                $usuario_apro = $servicio["usuario_apro"];
                $usuario_firm = $servicio["usuario_firm"];
                $id_fuente = $servicio["id_fuente"];
                $id_organismo = $servicio["id_organismo"];

                $beneficiario = $servicio["beneficiario"];
                $monto_benef = $servicio["monto_benef"];

                $banco_origen = $servicio["banco_origen"];
                $cuenta_origen = $servicio["cta_origen"];

                $idRubro = $servicio["id_rubro"];
                $idEntOtorg = $servicio["id_ent_otorgante"];

                if ($service_code == 'REG_CMF_REV_C21') {
                    $nro_devengado = $servicio["nro_preventivo"];
                    $nro_percibido = $servicio["nro_comprometido"];
                    $nro_secuencia = $servicio["nro_devengado"];
                }
            }
        }
        //f.e.a
        //$pxpRestClient = PxpRestClient2::connect('10.150.0.90', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin', 'admin');
        //echo($pxpRestClient->doPost('sigep/ServiceRequest/insertarServiceRequest', $servicio));exit;
        if ($momento == "REG_CON_FLUJO_C21") {
            if ($moneda == '34' || $moneda == '69') {
                $tipo = 'C';
            } else {
                $tipo = 'V';
            }

            $str = new stdClass();
            $str->usuario = "" . $usuario . "";
            $str->user_apro = "".$usuario_apro."";
            $str->user_firm = "".$usuario_firm."";
            $str->gestion = $gestion;

            $str->fechaElaboracion = "" . $fecha_elaboracion . "";

            $str->moneda = $moneda;
            $str->fechaTipoCambio = "" . $fecha_tipo_cambio . "";
            $str->compraVenta = "" . $tipo . "";
            $str->resumen = "" . $resumen . "";

            $str->totalMo = $total_autorizado;

            $str->sigade = NULL;
            $str->idConvenio = NULL;
            $str->idCatpry = NULL;

            $str->otfin = NULL;

            $str->idSolicitud = rand(1, 1000000);

            $str->respaldos  = array("documentoRespaldo" => "" . $tipo_doc_rdo . "", "nroDocRespaldo" => "" . $nro_doc_rdo . "", "fechaDocRespaldo" => "" . $fecha_elaboracion . "");
            $str->beneficiarios  = array("beneficiario" => "" . $beneficiario . "", "importeMo" => "" . $monto_benef . "");
            $str->libretas  = array("idFuente" => "" . $id_fuente . "", "idOrganismo" => "" . $id_organismo . "", "banco" => "" . $banco_origen . "", "cuenta" => "" . $cuenta_origen . "", "idRubro" => "" . $idRubro . "", "idEntOtorg" => "" . $idEntOtorg . "");

            $json = json_encode($str);
            $service_code = 'REG_CON_FLUJO_C21';
        }else if($momento == 'REG_CMF_REV_C21'){

            if ($moneda == '34' || $moneda == '69') {
                $tipo = 'C';
            } else {
                $tipo = 'V';
            }

            $str = new stdClass();
            $str->usuario = "" . $usuario . "";
            $str->user_apro = "".$usuario_apro."";
            $str->user_firm = "".$usuario_firm."";
            $str->gestion = $gestion;

            $str->docDevengado = $nro_devengado;
            $str->docPercibido = $nro_percibido;
            $str->secuenciaDoc = $nro_secuencia;

            $str->fechaElaboracion = "" . $fecha_elaboracion . "";

            $str->moneda = $moneda;
            $str->fechaTipoCambio = "" . $fecha_elaboracion . "";
            $str->compraVenta = "" . $tipo . "";
            $str->resumen = "" . $resumen . "";

            $str->totalMo = $total_autorizado;

            $str->sigade = NULL;
            $str->idConvenio = NULL;
            $str->idCatpry = NULL;

            $str->otfin = NULL;

            $str->idSolicitud = rand(1, 1000000);

            $str->respaldos  = array("documentoRespaldo" => "" . $tipo_doc_rdo . "", "nroDocRespaldo" => "" . $nro_doc_rdo . "", "fechaDocRespaldo" => "" . $fecha_elaboracion . "");
            $str->beneficiarios  = array("beneficiario" => "" . $beneficiario . "", "importeMo" => "" . $monto_benef . "");
            $str->libretas  = array("idFuente" => "" . $id_fuente . "", "idOrganismo" => "" . $id_organismo . "", "banco" => "" . $banco_origen . "", "cuenta" => "" . $cuenta_origen . "", "idRubro" => "" . $idRubro . "", "idEntOtorg" => "" . $idEntOtorg . "");

            $json = json_encode($str);

            $service_code = 'REG_CON_FLUJO_C21_REV';
        }
        //var_dump('json cargado:', $json, $service_code);exit;
        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin', 'admin');
        //var_dump('$pxpRestClient :', $pxpRestClient);exit;
        $variable = $pxpRestClient->doPost('sigep/ServiceRequest/insertarServiceRequestC21',
            array(	"sys_origin"=>'erp',
                "json"=>''.$json.'',
                "service_code"=>"".$service_code.""
            )
        );

        $result= json_decode($variable, true);
        //var_dump('$variable', $variable,'$result', $result);exit;

        $id_service_request=$result['ROOT']['datos']['id_service_request'];

        //var_dump('$id_service_request', $id_service_request,$id_adq, $estado_c21, $service_code);exit;
        $str = new stdClass();
        if($service_code == 'REG_CON_FLUJO_C21' || $service_code == 'REG_CON_FLUJO_C21_REV'){
            $this->actualizaEstados('registrado', $id_service_request, '','', $id_adq);
            //var_dump('actualizaEstados',$id_service_request, $id_adq,  $estado_c21);exit;
            $this->procesarServicesC21($id_service_request, $id_adq,  $estado_c21);
            $str->id_sigep_adq = "".$id_adq."";
            $str->service_code = "".$service_code."";

        }
        $str->id_sigep_adq = "".$id_adq."";
        $str->id_service_request = "" . $id_service_request . "";
        $this->respuesta = new Mensaje();
        $this->respuesta->setMensaje('EXITO', $this->nombre_archivo, 'Procesamiento exitoso ', 'Procesamiento exitoso ', 'modelo', $this->nombre_archivo, 'registrarServices', 'IME', '');
        $this->respuesta->setDatos($str);
        return $this->respuesta;
    }

    function procesarServicesC21($id_service_request , $id_adq, $estado_c21) {
        $momento = $this->objParam->getParametro('momento');
        $this->actualizaEstados('procesando', $id_service_request, '','', $id_adq);
        $response_status = true;
        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');
        while($response_status) {
            $variable = $pxpRestClient->doPost('sigep/SigepServiceRequest/procesarServicesC21',
                array(
                    "user" => 'admin',
                    "estado_c21" => $estado_c21,
                    "momento" => $momento
                )
            );
            $resul = json_decode($variable,true);//var_dump('VARIABLE ANTES: ',$resul, $variable);exit;
            $str = new stdClass();
            $str->resultado = "" . $resul . "";

            $next = json_decode($resul['ROOT']['datos']['end_process']);
            if( $next ){
                $response_status = $next;
                //var_dump('VARIABLE: ',$resul['ROOT']['datos'], $response_status, gettype($response_status));//exit;
            }else{
                $response_status = false;
            }
        }
        $this->respuesta = new Mensaje();
        $this->respuesta->setMensaje('EXITO', $this->nombre_archivo, 'Procesamiento exitoso ERP', 'Procesamiento exitoso ERP', 'modelo', $this->nombre_archivo, 'procesarServices', 'IME', '');
        $this->respuesta->setDatos($str);
        return $this->respuesta;
    }


    /******************** STATUS ********************/
    function StatusC21 (){
        $id_service_request = $this->objParam->getParametro('id_service_request');
        $service_code = $this->objParam->getParametro('service_code');
        $id_adq = $this->objParam->getParametro('id_sigep_adq');
        $id_int_comprobante = $this->objParam->getParametro('id_int_comprobante');
        $tipo = $this->objParam->getParametro('tipo');

        /*begin franklin.espinoza 21/09/2020*/
        $cone = new conexion();
        $link = $cone->conectarpdo();
        /*$sql = "UPDATE  conta.tint_comprobante SET
                  id_service_request = " . $id_service_request . "
                WHERE id_int_comprobante = " . $id_int_comprobante;
        $stmt = $link->prepare($sql);
        $stmt->execute();*/
        /*end franklin.espinoza 21/09/2020*/

        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

        $variable = $pxpRestClient->doPost('sigep/ServiceRequest/getServiceStatusC21',
            array(	"id_service_request"=>''.$id_service_request.''
            ));
        //var_dump('$variable', $variable);exit;
        $result= json_decode($variable, true);

        /*franklin.espinoza 16/09/2020 actualizar id_service_request*/

        if($result['ROOT']['datos']['status'] == 'success' || $result['ROOT']['datos']['status'] == 'pending'){
            $resp = $result['ROOT']['datos']['status'];
            if( $service_code == 'REG_CON_FLUJO_C21' ){
                $id_sigep_adq = $this->objParam->getParametro('id_sigep_adq');
                $docDevengado = $result['ROOT']['datos']['output']['docDevengado'];
                $docPercibido = $result['ROOT']['datos']['output']['docPercibido'];
                $secuenciaDoc = $result['ROOT']['datos']['output']['secuenciaDoc'];

                $sql = "UPDATE  conta.tint_comprobante SET
                  id_service_request = " . $id_service_request . ",
                  c21 = 'CMF " . $docDevengado . "," . $docPercibido . "," . $secuenciaDoc . "',
                  fecha_c21 = current_date
                WHERE id_int_comprobante = " . $id_int_comprobante;

                $stmt = $link->prepare($sql);
                $stmt->execute();

                $str = new stdClass();
                $str->docDevengado = "" . $docDevengado . "";
                $str->docPercibido = "" . $docPercibido . "";
                $str->secuenciaDoc = "" . $secuenciaDoc . "";
                $str->id_sigep_adq = "" . $id_sigep_adq . "";
                $str->service_code = "" . $service_code . "";
                $str->id_service_request = "" . $id_service_request . "";

                $this->actualizaEstadosC('finalizado', $id_service_request, $docDevengado, $docPercibido, $resp, $id_adq);
            }else if( $service_code == 'REG_CON_FLUJO_C21_REV' ){
                $id_sigep_adq = $this->objParam->getParametro('id_sigep_adq');
                $docDevengado = $result['ROOT']['datos']['output']['docDevengado'];
                $docPercibido = $result['ROOT']['datos']['output']['docPercibido'];
                $secuenciaDoc = $result['ROOT']['datos']['output']['secuenciaDoc'];

                $sql = "UPDATE  conta.tint_comprobante SET
                  id_service_request = " . $id_service_request . ",
                  c21 = 'REV CMF " . $docDevengado . "," . $docPercibido . "," . $secuenciaDoc . "',
                  fecha_c21 = current_date
                WHERE id_int_comprobante = " . $id_int_comprobante;

                $stmt = $link->prepare($sql);
                $stmt->execute();

                $str = new stdClass();
                $str->docDevengado = "" . $docDevengado . "";
                $str->docPercibido = "" . $docPercibido . "";
                $str->secuenciaDoc = "" . $secuenciaDoc . "";
                $str->id_sigep_adq = "" . $id_sigep_adq . "";
                $str->service_code = "" . $service_code . "";
                $str->id_service_request = "" . $id_service_request . "";

                $this->actualizaEstadosC('finalizado', $id_service_request, $docDevengado, $docPercibido, $resp, $id_adq);
            }
        }else{

            $error = $result['ROOT']['datos']['last_message'];
            $error = str_replace("MENSAJE:","", $error);
            $error = str_replace("CAUSA:","", $error);
            $error = str_replace("ACCION: ","", $error);
            //var_dump('finalizado nro:', $id_beneficiario);
            $str = new stdClass();
            $str->error = "" . $error . "";
            $str->id_service_request = "" . $id_service_request . "";

            $this->actualizaError('error', $id_service_request, $error, $id_adq);
        }

        $this->respuesta = new Mensaje();
        $this->respuesta->setMensaje('EXITO', $this->nombre_archivo, 'Procesamiento exitoso ', 'Procesamiento exitoso ', 'modelo', $this->nombre_archivo, 'procesarServices', 'IME', '');
        $this->respuesta->setDatos($str);
        return $this->respuesta;
    }
    /******************** STATUS ********************/


    /******************** INFO C21 ********************/
    function resultadoMsgC21(){

        $this->procedimiento='sigep.ft_sigep_action_ime';
        $this->transaccion='SIGEP_RESULT_C21';
        $this->tipo_procedimiento='IME';
        $this->arreglo['ids_input'] = $this->objParam->getParametro('ids');
        //Define los parametros para la funcion

        $this->setParametro('ids','ids','text');

        $this->armarConsulta();
        $this->ejecutarConsulta();

        return $this->respuesta;
    }
    /******************** INFO C21 ********************/
    /************************************************** C21 **************************************************/

    function StatusPassC31 (){


        $id_service_request = $this->objParam->getParametro('id_service_request');
        $id_comprobante = $this->objParam->getParametro('id_comprobante');
        $tipo = $this->objParam->getParametro('tipo');

        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

        $variable = $pxpRestClient->doPost('sigep/ServiceRequest/getServiceStatus',
            array(	"id_service_request"=>''.$id_service_request.''
            ));
        $result= json_decode($variable, true);

        if($result['ROOT']['datos']['status'] == 'success' || $result['ROOT']['datos']['status'] == 'pending'){
            $resp = $result['ROOT']['datos'];

            $str = new stdClass();
            $str->resultado_pass = $resp;
            /*$nro_preventivo = $result['ROOT']['datos']['output']['nroPreventivo'];
            $nro_comprometido = $result['ROOT']['datos']['output']['nroCompromiso'];
            $nro_devengado = $result['ROOT']['datos']['output']['nroDevengado'];*/
        }else{

            $error = $result['ROOT']['datos']['last_message'];
            $error = str_replace("MENSAJE:","", $error);
            $error = str_replace("CAUSA:","", $error);
            $error = str_replace("ACCION: ","", $error);
            $str = new stdClass();
            $str->error = "" . $error . "";
            $str->id_service_request = "" . $id_service_request . "";

        }

        $this->respuesta = new Mensaje();
        $this->respuesta->setMensaje('EXITO', $this->nombre_archivo, 'Procesamiento exitoso ', 'Procesamiento exitoso ', 'modelo', $this->nombre_archivo, 'procesarServices', 'IME', '');
        $this->respuesta->setDatos($str);
        return $this->respuesta;
    }

    function StatusPassC21 (){


        $id_service_request = $this->objParam->getParametro('id_service_request');
        $id_entrega = $this->objParam->getParametro('id_entrega');
        $tipo = $this->objParam->getParametro('tipo');

        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

        $variable = $pxpRestClient->doPost('sigep/ServiceRequest/getServiceStatus',
            array(	"id_service_request"=>''.$id_service_request.''
            ));
        $result= json_decode($variable, true);

        if($result['ROOT']['datos']['status'] == 'success' || $result['ROOT']['datos']['status'] == 'pending'){
            $resp = $result['ROOT']['datos'];

            $str = new stdClass();
            $str->resultado_pass = $resp;
            /*$nro_preventivo = $result['ROOT']['datos']['output']['nroPreventivo'];
            $nro_comprometido = $result['ROOT']['datos']['output']['nroCompromiso'];
            $nro_devengado = $result['ROOT']['datos']['output']['nroDevengado'];*/
        }else{

            $error = $result['ROOT']['datos']['last_message'];
            $error = str_replace("MENSAJE:","", $error);
            $error = str_replace("CAUSA:","", $error);
            $error = str_replace("ACCION: ","", $error);
            $str = new stdClass();
            $str->error = "" . $error . "";
            $str->id_service_request = "" . $id_service_request . "";

        }

        $this->respuesta = new Mensaje();
        $this->respuesta->setMensaje('EXITO', $this->nombre_archivo, 'Procesamiento exitoso ', 'Procesamiento exitoso ', 'modelo', $this->nombre_archivo, 'procesarServices', 'IME', '');
        $this->respuesta->setDatos($str);
        return $this->respuesta;
    }

    function registrarResultadoC21(){

        $this->procedimiento='sigep.ft_sigep_action_ime';
        $this->transaccion='SIGEP_UPD_DOCUMENTO';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_sigep_adq','id_sigep_adq','int4');
        $this->setParametro('nro_preventivo','nro_preventivo','varchar');
        $this->setParametro('nro_comprometido','nro_comprometido','varchar');
        $this->setParametro('nro_devengado','nro_devengado','varchar');

        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump('consulta benef:',$this->respuesta);
        return $this->respuesta;
    }

    function actualizaEstados($estado, $dato, $preve, $mensaje, $valor) {
        if ($preve == ''){
            $preve = null;
        }
        $cone = new conexion();
        $link = $cone->conectarpdo();

        $sql = "UPDATE  sigep.tsigep_adq
                SET estado = '".$estado."',
                  id_service_request = ".$dato.",
                  nro_preventivo = ".$preve."::integer,
                  ultimo_mensaje = '".$mensaje."'
                WHERE id_sigep_adq =$valor";

        $stmt = $link->prepare($sql);
        $stmt->execute();
    }

    function actualizaEstadosC($estado, $dato, $compro, $deven, $mensaje, $valor) {
        $cone = new conexion();
        $link = $cone->conectarpdo();

        $sql = "UPDATE  sigep.tsigep_adq
                SET estado = '".$estado."',
                  id_service_request = ".$dato.",
                  nro_comprometido = ".$compro."::integer,
                  nro_devengado = ".$deven."::integer,
                  ultimo_mensaje = '".$mensaje."'
                WHERE id_sigep_adq =$valor";

        $stmt = $link->prepare($sql);
        $stmt->execute();
    }

}
?>