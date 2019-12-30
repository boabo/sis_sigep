<?php
/**
 *@package pXP
 *@file gen-ACTSigepAdqDet.php
 *@author  (rzabala)
 *@date 25-03-2019 15:50:47
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTSigepAdqDet extends ACTbase{

    function listarSigepAdqDet(){
        $this->objParam->defecto('ordenacion','id_sigep_adq_det');

        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('id_sigep_adq') != '') {
            $this->objParam->addFiltro("sad.id_sigep_adq = ".$this->objParam->getParametro('id_sigep_adq'));
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODSigepAdqDet','listarSigepAdqDet');
        } else{
            $this->objFunc=$this->create('MODSigepAdqDet');

            $this->res=$this->objFunc->listarSigepAdqDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarSigepAdqDet(){
        $this->objFunc=$this->create('MODSigepAdqDet');

        if($this->objParam->insertar('id_sigep_adq_det')){
            $this->res=$this->objFunc->insertarSigepAdqDet($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarSigepAdqDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarSigepAdqDet(){
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->eliminarSigepAdqDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function cargarSigepAdqDet(){
        $this->objFunc=$this->create('MODSigepAdqDet');

        $this->res=$this->objFunc->cargarSigepAdqDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    /*function cargarSigepContDet(){//var_dump('cargarSigepContDet');
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarSigepContDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }*/
    function cargarSigepCip(){//var_dump('cargarSigepContDet');
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarSigepCip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function cargarSigepPlani(){//var_dump('cargarSigepContDet');
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarSigepPlani($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function cargarSigepReguDet(){//var_dump('cargarSigepContDet');
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarSigepReguDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function cargarSigepSip(){//var_dump('cargarSigepContDet');
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarSigepSip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>