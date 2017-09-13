<?php
/**
*@package pXP
*@file gen-ACTClaseGastoSip.php
*@author  (franklin.espinoza)
*@date 07-09-2017 15:41:47
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTClaseGastoSip extends ACTbase{    
			
	function listarClaseGastoSip(){
		$this->objParam->defecto('ordenacion','id_clase_gasto_sip');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODClaseGastoSip','listarClaseGastoSip');
		} else{
			$this->objFunc=$this->create('MODClaseGastoSip');
			
			$this->res=$this->objFunc->listarClaseGastoSip($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarClaseGastoSip(){
		$this->objFunc=$this->create('MODClaseGastoSip');	
		if($this->objParam->insertar('id_clase_gasto_sip')){
			$this->res=$this->objFunc->insertarClaseGastoSip($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarClaseGastoSip($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarClaseGastoSip(){
			$this->objFunc=$this->create('MODClaseGastoSip');	
		$this->res=$this->objFunc->eliminarClaseGastoSip($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>