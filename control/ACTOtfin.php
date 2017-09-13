<?php
/**
*@package pXP
*@file gen-ACTOtfin.php
*@author  (franklin.espinoza)
*@date 07-09-2017 18:59:47
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTOtfin extends ACTbase{    
			
	function listarOtfin(){
		$this->objParam->defecto('ordenacion','id_otfin');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODOtfin','listarOtfin');
		} else{
			$this->objFunc=$this->create('MODOtfin');
			
			$this->res=$this->objFunc->listarOtfin($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarOtfin(){
		$this->objFunc=$this->create('MODOtfin');	
		if($this->objParam->insertar('id_otfin')){
			$this->res=$this->objFunc->insertarOtfin($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarOtfin($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarOtfin(){
			$this->objFunc=$this->create('MODOtfin');	
		$this->res=$this->objFunc->eliminarOtfin($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>