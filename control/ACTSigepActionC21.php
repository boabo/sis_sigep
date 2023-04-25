<?php
/**
 *@package BoA
 *@file     ACTSigepActionC21.php
 *@author  (franklin.espinoza)
 *@date     10/12/2021 21:10:26
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */
include_once(dirname(__FILE__).'/../rest/PxpRestSigep.php');

class ACTSigepActionC21 extends ACTbase{

    /************************************************** C21 **************************************************/
    function listarSigepActionC21(){
        $this->objParam->defecto('ordenacion','id_sigep_adq');

        $this->objParam->defecto('dir_ordenacion','desc');

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODSigepActionC21','listarSigepActionC21');
        } else{
            $this->objFunc=$this->create('MODSigepActionC21');

            $this->res=$this->objFunc->listarSigepActionC21($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    /*{developer: franklin.espinoza, date:16/12/2020, description: "Cambia el estado para aprobaciones C21 Sistema Sigep"}*/
    function processChangeStates(){

        $id_service_request = $this->objParam->getParametro('id_service_request');
        $estado_reg = $this->objParam->getParametro('estado_reg');
        $direction = $this->objParam->getParametro('direction');

        $momento = $this->objParam->getParametro('momento');

        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin', 'admin');
        $request = $pxpRestClient->doPost('sigep/ServiceRequest/processChangeStates',
            array(
                "id_service_request" => $id_service_request,
                "estado_reg" => $estado_reg,
                "direction" => $direction
            )
        );

        $response = json_decode($request, true);//var_dump('$response', $response);exit;

        $process = json_decode($response["ROOT"]['datos']["v_process"]);

        if($process){
            $response_status = true;
            $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

            while($response_status) {
                $request = $pxpRestClient->doPost('sigep/SigepServiceRequest/procesarServicesC21',
                    array(
                        "user" => 'admin',
                        "estado_c21" => $estado_reg,
                        "momento" => $momento,
                        "id_service_request" => $this->objParam->getParametro('id_service_request')
                    )
                );
                $response = json_decode($request,true);

                $next = json_decode($response['ROOT']['datos']['end_process']);
                if( $next ){
                    $response_status = $next;
                }else{
                    $response_status = false;
                }
            }
        }

        $this->res=new Mensaje();
        $this->res->setMensaje('EXITO','SigepActionC21.php','Estados Servicios', 'Cambio de Estados de Servicios','control');
        $this->res->setDatos(array('process' => $process, 'sigep_data' => $response['ROOT']['datos'], 'mensaje'=>$process?'cambio exitoso de estados.':'cambio fallido de estados'));
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    function getParametrosC21(){
        $this->objFunc=$this->create('MODSigepActionC21');
        $this->res=$this->objFunc->getParametrosC21($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function registrarServicesC21(){
        $this->objFunc=$this->create('MODSigepActionC21');
        $this->res=$this->objFunc->registrarServicesC21($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function StatusC21(){
        $this->objFunc=$this->create('MODSigepActionC21');
        $this->res=$this->objFunc->StatusC21($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function registrarResultadoC21(){
        $this->objFunc=$this->create('MODSigepActionC21');
        $this->res=$this->objFunc->registrarResultadoC21($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function resultadoMsgC21(){
        $this->objFunc=$this->create('MODSigepActionC21');
        $this->res=$this->objFunc->resultadoMsgC21($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    /*{developer: franklin.espinoza, date:27/12/2022, description: "Cambia el estado para aprobaciones C21 Sistema Sigep"}*/
    function readyProcesoSigepC21(){

        $cone = new conexion();
        $link = $cone->conectarpdo();

        $sql = "select tus.cuenta
                from segu.tusuario tus
                where tus.id_usuario = ".$_SESSION["ss_id_usuario"]."
                ";
        $consulta = $link->query($sql);
        $consulta->execute();
        $cuenta = $consulta->fetchAll(PDO::FETCH_ASSOC);
        $cuenta = $cuenta[0]['cuenta'];

        $estado_reg = $this->objParam->getParametro('estado_reg');
        $momento = $this->objParam->getParametro('momento');
        $id_service_request = $this->objParam->getParametro('id_service_request');
        $direction = $this->objParam->getParametro('direction');

        //var_dump($estado_reg, $momento, $id_service_request, $direction);exit;
        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin', 'admin');
        $request = $pxpRestClient->doPost('sigep/ServiceRequest/readyProcesoSigepC21',
            array(
                "id_service_request" => $id_service_request,
                "direction" => $direction,
                "estado_reg" => $estado_reg,
                "cuenta" => $cuenta
            )
        );


        $response = json_decode($request, true);//var_dump($request);exit;

        $process = json_decode($response["ROOT"]['datos']["v_process"]);
        //var_dump('valores',$process, $estado_reg, $momento);exit;
        if($process){

            $response_status = true;
            $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

            while($response_status) {
                $request = $pxpRestClient->doPost('sigep/SigepServiceRequest/procesarServicesC21',
                    array(
                        "user" => 'admin',
                        "estado_c21" => $estado_reg,
                        "momento" => $momento,
                        "id_service_request" => $this->objParam->getParametro('id_service_request')
                    )
                );
                $response = json_decode($request,true);//var_dump('$request', $request);exit;

                $next = json_decode($response['ROOT']['datos']['end_process']);
                if( $next ){
                    $response_status = $next;
                }else{
                    $response_status = false;
                }
            }
        }

        $this->res=new Mensaje();
        $this->res->setMensaje('EXITO','SigepAdq.php','Estados Servicios', 'Cambio de Estados de Servicios','control');
        $this->res->setDatos(array('process' => $process, 'sigep_data' => $response['ROOT']['datos'], 'mensaje'=>$process?'cambio exitoso de estados.':'cambio fallido de estados'));
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    /*{developer: franklin.espinoza, date:15/09/2020, description: "Elimina C31 Sistema Sigep"}*/
    function revertirProcesoSigepC21(){

        $id_service_request = $this->objParam->getParametro('id_service_request');
        $estado_reg = $this->objParam->getParametro('estado_reg');
        $estado_destino = $this->objParam->getParametro('estado_destino');

        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin', 'admin');
        $request = $pxpRestClient->doPost('sigep/ServiceRequest/revertirProcesoSigepC21',
            array(
                "id_service_request" => $id_service_request
            )
        );


        $response = json_decode($request, true);

        $process = json_decode($response["ROOT"]['datos']["v_process"]);

        //var_dump($process);exit;

        if($process){

            $response_status = true;
            $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

            while($response_status) {
                $request = $pxpRestClient->doPost('sigep/SigepServiceRequest/procesarServicesC21', array("user" => 'admin' ));
                $response = json_decode($request,true);

                $next = json_decode($response['ROOT']['datos']['end_process']);
                if( $next ){
                    $response_status = $next;
                }else{
                    $response_status = false;
                }
            }
        }

        if ( $estado_reg == 'elaborado' && $estado_destino == 'anterior') {
            $cone = new conexion();
            $link = $cone->conectarpdo();

            $sql = "UPDATE  conta.tint_comprobante SET
                        c21 = null
                    WHERE id_service_request = " . $id_service_request;

            $stmt = $link->prepare($sql);
            $stmt->execute();
        }

        $this->res=new Mensaje();
        $this->res->setMensaje('EXITO','SigepAdq.php','Estados Servicios', 'Cambio de Estados de Servicios','control');
        $this->res->setDatos(array('process' => $process, 'sigep_data' => $response['ROOT']['datos'], 'mensaje'=>$process?'cambio exitoso de estados.':'cambio fallido de estados'));
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    /************************************************** C21 **************************************************/
}

?>