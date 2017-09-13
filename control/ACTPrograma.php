<?php
/**
*@package pXP
*@file gen-ACTPrograma.php
*@author  (franklin.espinoza)
*@date 06-09-2017 20:53:14
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPrograma extends ACTbase{    
			
	function listarPrograma(){
		$this->objParam->defecto('ordenacion','id_programa_boa');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPrograma','listarPrograma');
		} else{
			$this->objFunc=$this->create('MODPrograma');
			
			$this->res=$this->objFunc->listarPrograma($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPrograma(){
		$this->objFunc=$this->create('MODPrograma');	
		if($this->objParam->insertar('id_programa_boa')){
			$this->res=$this->objFunc->insertarPrograma($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPrograma($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPrograma(){
			$this->objFunc=$this->create('MODPrograma');	
		$this->res=$this->objFunc->eliminarPrograma($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>