<?php
/**
 *@package pXP
 *@file gen-ACTDocumentoRespaldo.php
 *@author  Maylee Perez Pastor
 *@date 16-10-2019  15:11:16
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTMulta extends ACTbase{

    function listarMulta(){
        $this->objParam->defecto('ordenacion','id_multa');

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODMulta','listarMulta');
        } else{
            $this->objFunc=$this->create('MODMulta');

            $this->res=$this->objFunc->listarMulta($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarMulta(){
        $this->objFunc=$this->create('MODMulta');
        if($this->objParam->insertar('id_multa')){
            $this->res=$this->objFunc->insertarMulta($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarMulta($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarMulta(){
        $this->objFunc=$this->create('MODMulta');
        $this->res=$this->objFunc->eliminarMulta($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>