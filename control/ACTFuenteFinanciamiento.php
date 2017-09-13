<?php
/**
*@package pXP
*@file gen-ACTFuenteFinanciamiento.php
*@author  (franklin.espinoza)
*@date 30-08-2017 15:54:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFuenteFinanciamiento extends ACTbase{    
			
	function listarFuenteFinanciamiento(){
		$this->objParam->defecto('ordenacion','id_fuente_financiamiento');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFuenteFinanciamiento','listarFuenteFinanciamiento');
		} else{
			$this->objFunc=$this->create('MODFuenteFinanciamiento');
			
			$this->res=$this->objFunc->listarFuenteFinanciamiento($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFuenteFinanciamiento(){
		$this->objFunc=$this->create('MODFuenteFinanciamiento');	
		if($this->objParam->insertar('id_fuente_financiamiento')){
			$this->res=$this->objFunc->insertarFuenteFinanciamiento($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFuenteFinanciamiento($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFuenteFinanciamiento(){
			$this->objFunc=$this->create('MODFuenteFinanciamiento');	
		$this->res=$this->objFunc->eliminarFuenteFinanciamiento($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>