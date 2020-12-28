<?php
/**
*@package pXP
*@file gen-ACTPresupuestoGasto.php
*@author  (franklin.espinoza)
*@date 06-09-2017 21:27:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPresupuestoGasto extends ACTbase{    
			
	function listarPresupuestoGasto(){
		$this->objParam->defecto('ordenacion','id_presupuesto_gasto');
		$this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("pre_gas.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupuestoGasto','listarPresupuestoGasto');
		} else{
			$this->objFunc=$this->create('MODPresupuestoGasto');
			
			$this->res=$this->objFunc->listarPresupuestoGasto($this->objParam);
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