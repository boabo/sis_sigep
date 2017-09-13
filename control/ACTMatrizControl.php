<?php
/**
*@package pXP
*@file gen-ACTMatrizControl.php
*@author  (franklin.espinoza)
*@date 08-09-2017 18:56:26
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTMatrizControl extends ACTbase{    
			
	function listarMatrizControl(){
		$this->objParam->defecto('ordenacion','id_matriz_control');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMatrizControl','listarMatrizControl');
		} else{
			$this->objFunc=$this->create('MODMatrizControl');
			
			$this->res=$this->objFunc->listarMatrizControl($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMatrizControl(){
		$this->objFunc=$this->create('MODMatrizControl');	
		if($this->objParam->insertar('id_matriz_control')){
			$this->res=$this->objFunc->insertarMatrizControl($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMatrizControl($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMatrizControl(){
			$this->objFunc=$this->create('MODMatrizControl');	
		$this->res=$this->objFunc->eliminarMatrizControl($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>