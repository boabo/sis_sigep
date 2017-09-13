<?php
/**
*@package pXP
*@file gen-ACTClaseGastoCip.php
*@author  (franklin.espinoza)
*@date 07-09-2017 15:28:46
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTClaseGastoCip extends ACTbase{    
			
	function listarClaseGastoCip(){
		$this->objParam->defecto('ordenacion','id_clase_gasto_cip');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODClaseGastoCip','listarClaseGastoCip');
		} else{
			$this->objFunc=$this->create('MODClaseGastoCip');
			
			$this->res=$this->objFunc->listarClaseGastoCip($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarClaseGastoCip(){
		$this->objFunc=$this->create('MODClaseGastoCip');	
		if($this->objParam->insertar('id_clase_gasto_cip')){
			$this->res=$this->objFunc->insertarClaseGastoCip($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarClaseGastoCip($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarClaseGastoCip(){
			$this->objFunc=$this->create('MODClaseGastoCip');	
		$this->res=$this->objFunc->eliminarClaseGastoCip($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>