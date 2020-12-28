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
    function cargarSigepCip(){
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

    function cargarSigepReguCip(){
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarSigepReguCip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function cargarSigepReguSip(){
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarSigepReguSip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    //{develop:franklin.espinoza date:27/09/2020}
    function cargarEntregaSigepReguCip(){
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarEntregaSigepReguCip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    //{develop:franklin.espinoza date:27/09/2020}
    function cargarEntregaSigepReguSip(){
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarEntregaSigepReguSip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    //{develop:franklin.espinoza date:15/10/2020}
    function cargarEntregaSigepCip(){
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarEntregaSigepCip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    //{develop:franklin.espinoza date:09/11/2020}
    function cargarEntregaSigepReguReverCip(){
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarEntregaSigepReguReverCip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    //{develop:franklin.espinoza date:23/11/2020}
    function cargarEntregaSigepReguReverSip(){
        $this->objFunc=$this->create('MODSigepAdqDet');
        $this->res=$this->objFunc->cargarEntregaSigepReguReverSip($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>