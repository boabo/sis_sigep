<?php
/**
*@package pXP
*@file gen-ACTSigade.php
*@author  (franklin.espinoza)
*@date 07-09-2017 18:46:18
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTSigade extends ACTbase{    
			
	function listarSigade(){
		$this->objParam->defecto('ordenacion','id_sigade');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSigade','listarSigade');
		} else{
			$this->objFunc=$this->create('MODSigade');
			
			$this->res=$this->objFunc->listarSigade($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarSigade(){
		$this->objFunc=$this->create('MODSigade');	
		if($this->objParam->insertar('id_sigade')){
			$this->res=$this->objFunc->insertarSigade($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSigade($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSigade(){
			$this->objFunc=$this->create('MODSigade');	
		$this->res=$this->objFunc->eliminarSigade($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>