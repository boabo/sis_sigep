<?php
/**
*@package pXP
*@file gen-ACTUnidadEjecutora.php
*@author  (franklin.espinoza)
*@date 06-09-2017 20:53:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTUnidadEjecutora extends ACTbase{    
			
	function listarUnidadEjecutora(){
		$this->objParam->defecto('ordenacion','id_unidad_ejecutora');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODUnidadEjecutora','listarUnidadEjecutora');
		} else{
			$this->objFunc=$this->create('MODUnidadEjecutora');
			
			$this->res=$this->objFunc->listarUnidadEjecutora($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarUnidadEjecutora(){
		$this->objFunc=$this->create('MODUnidadEjecutora');	
		if($this->objParam->insertar('id_unidad_ejecutora')){
			$this->res=$this->objFunc->insertarUnidadEjecutora($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarUnidadEjecutora($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarUnidadEjecutora(){
			$this->objFunc=$this->create('MODUnidadEjecutora');	
		$this->res=$this->objFunc->eliminarUnidadEjecutora($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>