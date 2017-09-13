<?php
/**
*@package pXP
*@file gen-ACTDocumentoRespaldo.php
*@author  (franklin.espinoza)
*@date 07-09-2017 15:11:16
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDocumentoRespaldo extends ACTbase{    
			
	function listarDocumentoRespaldo(){
		$this->objParam->defecto('ordenacion','id_documento_respaldo');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDocumentoRespaldo','listarDocumentoRespaldo');
		} else{
			$this->objFunc=$this->create('MODDocumentoRespaldo');
			
			$this->res=$this->objFunc->listarDocumentoRespaldo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDocumentoRespaldo(){
		$this->objFunc=$this->create('MODDocumentoRespaldo');	
		if($this->objParam->insertar('id_documento_respaldo')){
			$this->res=$this->objFunc->insertarDocumentoRespaldo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDocumentoRespaldo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDocumentoRespaldo(){
			$this->objFunc=$this->create('MODDocumentoRespaldo');	
		$this->res=$this->objFunc->eliminarDocumentoRespaldo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>