<?php
/**
 *@package pXP
 *@file gen-ACTSigepAdq.php
 *@author  (rzabala)
 *@date 15-03-2019 21:10:26
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */
//require_once(dirname(__FILE__).'/../rest/PxpRestClient2.php');

class ACTSigepAdq extends ACTbase{

    function listarSigepAdq(){
        $this->objParam->defecto('ordenacion','id_sigep_adq');

        $this->objParam->defecto('dir_ordenacion','asc');

        //$result = $this->objParam->getParametro('sigep_adq');
        //var_dump('estoy N ACT:', $result);exit;

        if ( $this->objParam->getParametro('sigep_adq') == 'vbsigepadq' ) {

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
        }

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
    function StatusC31(){
        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->StatusC31($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function resultadoMsg(){
        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->resultadoMsg($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function consultaMonSigep(){

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
        //var_dump('service_code:', $service_code);exit;
        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->registrarServiceERP('empty',$list,$service_code);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function registrarBeneficiario(){

        $this->objFunc=$this->create('MODSigepAdq');
        $this->res=$this->objFunc->registrarBeneficiario();
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>