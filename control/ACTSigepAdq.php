<?php
/**
 *@package pXP
 *@file gen-ACTSigepAdq.php
 *@author  (rzabala)
 *@date 15-03-2019 21:10:26
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */
//require_once(dirname(__FILE__).'/../rest/PxpRestClient2.php');
include_once(dirname(__FILE__).'/../rest/PxpRestSigep.php');
class ACTSigepAdq extends ACTbase{

    function listarSigepAdq(){
        $this->objParam->defecto('ordenacion','id_sigep_adq');

        $this->objParam->defecto('dir_ordenacion','desc');

        //$result = $this->objParam->getParametro('sigep_adq');
        //var_dump('estoy N ACT:', $result);exit;

        /*if ( $this->objParam->getParametro('sigep_adq') == 'vbsigepadq' ) {

            $this->objParam->addFiltro("sadq.num_tramite::varchar = ''". $this->objParam->getParametro('num_tramite')."''::varchar and sadq.estado in(''pre-registro'',''registrado'',''procesando'',''finalizado'', ''error'') and sadq.momento in (''PREVENTIVO'')");
        }
        if ( $this->objParam->getParametro('sigep_adq') == 'vbsigepconta' ) {

            $this->objParam->addFiltro("sadq.num_tramite::varchar = ''". $this->objParam->getParametro('num_tramite')."''::varchar and sadq.estado in(''pre-registro'',''registrado'',''procesando'',''finalizado'', ''error'') and sadq.momento in (''COMPROMETIDO-DEVENGADO'', ''PREVENTIVO'') and sadq.nro_preventivo is not null");
        }
        if ( $this->objParam->getParametro('sigep_adq') == 'vbsigepcontaregu' ) {

            $this->objParam->addFiltro("sadq.num_tramite::varchar = ''". $this->objParam->getParametro('num_tramite')."''::varchar and sadq.estado in(''pre-registro'',''registrado'',''procesando'',''finalizado'', ''error'') and sadq.momento in (''COMPROMETIDO-DEVENGADO'', ''PREVENTIVO'', ''REGULARIZACION'')");
        }
        if ( $this->objParam->getParametro('sigep_adq') == 'vbsigepsip' ) {

            $this->objParam->addFiltro("sadq.num_tramite::varchar = ''". $this->objParam->getParametro('num_tramite')."''::varchar and sadq.estado in(''pre-registro'',''registrado'',''procesando'',''finalizado'', ''error'') and sadq.momento in (''COMPROMETIDO-DEVENGADO'', ''PREVENTIVO'', ''REGULARIZACION'')");
        }*/

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODSigepAdq','listarSigepAdq');
        } else{
            $this->objFunc=$this->create('MODSigepAdq');

            $this->res=$this->objFunc->listarSigepAdq($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarSigepAdq(){
        $this->objFunc=$this->create('MODSigepAdq');
        if($this->objParam->insertar('id_sigep_adq')){
            $this->res=$this->objFunc->insertarSigepAdq($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarSigepAdq($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarSigepAdq(){
        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->eliminarSigepAdq($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function ReenviarC31(){
        $this->objFunc=$this->create('MODSigepAdq');
        //if($this->objParam->insertar('id_sigep_adq')){
        $this->res=$this->objFunc->ReenviarC31($this->objParam);
        //}
        //var_dump($this->res->imprimirRespuesta($this->res->generarJson()));exit;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function ProcesarC31(){
        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->ProcesarC31($this->objParam, 15);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function StatusC31(){//var_dump('StatusC31');exit;
        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->StatusC31($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function resultadoMsg(){
        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->resultadoMsg($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function consultaMonSigep(){ //var_dump('consultaMonSigep',$this->objParam->getParametro('id_sigep_adq'));exit;
        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->consultaMonSigep($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function registrarPreventivo(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->registrarPreventivo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function registrarComprometidoDevengado(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->registrarComprometidoDevengado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function registrarResultado(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->registrarResultado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function consultaBeneficiario(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->consultaBeneficiario($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function consultaDelete(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->consultaDelete($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function registrarService(){
        $list = $this->objParam->getParametro('list');
        $service_code = $this->objParam->getParametro ('service_code');
        $estado_c31 = $this->objParam->getParametro ('estado_c31');

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->registrarServiceERP('empty', $list, $service_code, $estado_c31);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function registrarBeneficiario(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->registrarBeneficiario();
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    /*{developer: franklin.espinoza, date:27/08/20202, description: "Aprobar C31 Sistema Sigep"}*/
    function aprobarC31(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->aprobarC31();
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    /*{developer: franklin.espinoza, date:27/08/20202, description: "Firmar C31 Sistema Sigep"}*/
    function firmarC31(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->firmarC31();
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    /*{developer: franklin.espinoza, date:15/09/2020, description: "Elimina C31 Sistema Sigep"}*/
    function revertirProcesoSigep(){

        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin', 'admin');

        $request = $pxpRestClient->doPost('sigep/ServiceRequest/revertirProcesoSigep',
            array(
                "id_service_request" => $this->objParam->getParametro('id_service_request')
            )
        );


        $response = json_decode($request, true);

        $process = json_decode($response["ROOT"]['datos']["v_process"]);

        //var_dump($process);exit;

        if($process){

            $response_status = true;
            $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

            while($response_status) {
                $request = $pxpRestClient->doPost('sigep/SigepServiceRequest/procesarServices', array("user" => 'admin' ));
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
        $this->res->setMensaje('EXITO','SigepAdq.php','Estados Servicios', 'Cambio de Estados de Servicios','control');
        $this->res->setDatos(array('process' => $process, 'sigep_data' => $response['ROOT']['datos'], 'mensaje'=>$process?'cambio exitoso de estados.':'cambio fallido de estados'));
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    /*{developer: franklin.espinoza, date:15/09/2020, description: "Cambia el estado para aprobaciones C31 Sistema Sigep"}*/
    function readyProcesoSigep(){

        $estado_reg = $this->objParam->getParametro('estado_reg');//var_dump($estado_reg);
        $momento = $this->objParam->getParametro('momento');//var_dump($momento, $this->objParam->getParametro('direction'));exit;
//var_dump('valores',$this->objParam->getParametro('id_service_request'),$this->objParam->getParametro('direction'),$estado_reg);exit;
        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin', 'admin');

        $request = $pxpRestClient->doPost('sigep/ServiceRequest/readyProcesoSigep',
            array(
                "id_service_request" => $this->objParam->getParametro('id_service_request'),
                "direction" => $this->objParam->getParametro('direction'),
                "estado_reg" => $estado_reg
            )
        );


        $response = json_decode($request, true);//var_dump($request);exit;

        $process = json_decode($response["ROOT"]['datos']["v_process"]);
        //var_dump('valores',$process, $estado_reg, $momento);exit;
        if($process){

            $response_status = true;
            $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

            while($response_status) {
                $request = $pxpRestClient->doPost('sigep/SigepServiceRequest/procesarServices',
                    array(
                        "user" => 'admin',
                        "estado_c31" => $estado_reg,
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
        $this->res->setMensaje('EXITO','SigepAdq.php','Estados Servicios', 'Cambio de Estados de Servicios','control');
        $this->res->setDatos(array('process' => $process, 'sigep_data' => $response['ROOT']['datos'], 'mensaje'=>$process?'cambio exitoso de estados.':'cambio fallido de estados'));
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    /*{developer: franklin.espinoza, date:27/09/2020, description: "Preparar Datos para actualizar C31 en el Sistema Sigep"}*/
    function setupSigepProcess(){

        $estado_reg = $this->objParam->getParametro('estado_reg');
        $momento = $this->objParam->getParametro('momento');
        $id_entrega = $this->objParam->getParametro('id_entrega');

        $cone = new conexion();
        $link = $cone->conectarpdo();

        $sql = "SELECT sig.nro_preventivo, sig.nro_comprometido, sig.nro_devengado 
                FROM sigep.tsigep_adq sig
                WHERE  sig.id_int_comprobante = ". $id_entrega;

        $preventivo = '';
        $compromiso = '';
        $devengado = '';
        foreach ($record = $link->query($sql) as $row) {
            $preventivo = $row['nro_preventivo'];
            $compromiso = $row['nro_comprometido'];
            $devengado = $row['nro_devengado'];
        } //var_dump('documento', $preventivo, $compromiso, $devengado);exit;


        $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin', 'admin');

        //var_dump($this->objParam->getParametro('json_data'));exit;
        $request = $pxpRestClient->doPost('sigep/SigepServiceRequest/setupSigepProcess',
            array(
                "id_service_request" => $this->objParam->getParametro('id_service_request'),
                "json_data" => $this->objParam->getParametro('json_data'),
                "id_service_request" => $this->objParam->getParametro('id_service_request'),
                "estado_reg" => $estado_reg,
                "clase_comprobante" => $this->objParam->getParametro('clase_comprobante'),
                "preventivo" => $preventivo,
                "compromiso" => $compromiso,
                "devengado" => $devengado
            )
        );


        $response = json_decode($request, true);//var_dump('resultado',$response);exit;

        $process = json_decode($response["ROOT"]['datos']["response_status"]);
        //var_dump($process);exit;
        /*if($process){

            $response_status = true;
            $pxpRestClient = PxpRestClient2::connect('172.17.58.62', 'kerp/pxp/lib/rest/')->setCredentialsPxp('admin','admin');

            while($response_status) {
                $request = $pxpRestClient->doPost('sigep/SigepServiceRequest/procesarServices',
                    array(
                        "user" => 'admin',
                        "estado_c31" => $estado_reg,
                        "momento" => $momento
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
        }*/

        $this->res=new Mensaje();
        $this->res->setMensaje('EXITO','SigepAdq.php','Estados Servicios', 'Cambio de Estados de Servicios','control');
        $this->res->setDatos(array('process' => $process, 'sigep_data' => $response['ROOT']['datos'], 'mensaje'=>$process?'guardado exitoso de datos.':'guardado fallido de datos'));
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

}

?>