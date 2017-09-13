<?php
/**
*@package pXP
*@file gen-ACTBanco.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:37:46
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTBanco extends ACTbase{    
			
	function listarBanco(){
		$this->objParam->defecto('ordenacion','id_banco_boa');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODBanco','listarBanco');
		} else{
			$this->objFunc=$this->create('MODBanco');
			
			$this->res=$this->objFunc->listarBanco($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarBanco(){
		$this->objFunc=$this->create('MODBanco');	
		if($this->objParam->insertar('id_banco_boa')){
			$this->res=$this->objFunc->insertarBanco($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarBanco($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarBanco(){
			$this->objFunc=$this->create('MODBanco');	
		$this->res=$this->objFunc->eliminarBanco($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>