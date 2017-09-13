<?php
/**
*@package pXP
*@file gen-ACTLibreta.php
*@author  (franklin.espinoza)
*@date 08-09-2017 14:59:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTLibreta extends ACTbase{    
			
	function listarLibreta(){
		$this->objParam->defecto('ordenacion','id_libreta_boa');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODLibreta','listarLibreta');
		} else{
			$this->objFunc=$this->create('MODLibreta');
			
			$this->res=$this->objFunc->listarLibreta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarLibreta(){
		$this->objFunc=$this->create('MODLibreta');	
		if($this->objParam->insertar('id_libreta_boa')){
			$this->res=$this->objFunc->insertarLibreta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarLibreta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarLibreta(){
			$this->objFunc=$this->create('MODLibreta');	
		$this->res=$this->objFunc->eliminarLibreta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>