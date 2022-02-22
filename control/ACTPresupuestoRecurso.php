<?php
/**
 *@package pXP
 *@file gen-ACTPresupuestoRecurso.php
 *@author  (franklin.espinoza)
 *@date 06-09-2017 21:27:23
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTPresupuestoRecurso extends ACTbase{

    function listarPresupuestoRecurso(){
        $this->objParam->defecto('ordenacion','id_presupuesto_gasto');

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPresupuestoRecurso','listarPresupuestoRecurso');
        } else{
            $this->objFunc=$this->create('MODPresupuestoRecurso');

            $this->res=$this->objFunc->listarPresupuestoRecurso($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarPresupuestoGasto(){
        $this->objFunc=$this->create('MODPresupuestoGasto');
        if($this->objParam->insertar('id_presupuesto_gasto')){
            $this->res=$this->objFunc->insertarPresupuestoGasto($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarPresupuestoGasto($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarPresupuestoGasto(){
        $this->objFunc=$this->create('MODPresupuestoGasto');
        $this->res=$this->objFunc->eliminarPresupuestoGasto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>