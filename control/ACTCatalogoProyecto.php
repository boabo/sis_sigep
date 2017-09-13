<?php
/**
*@package pXP
*@file gen-ACTCatalogoProyecto.php
*@author  (franklin.espinoza)
*@date 06-09-2017 21:31:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCatalogoProyecto extends ACTbase{    
			
	function listarCatalogoProyecto(){
		$this->objParam->defecto('ordenacion','id_catalogo_proyecto');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCatalogoProyecto','listarCatalogoProyecto');
		} else{
			$this->objFunc=$this->create('MODCatalogoProyecto');
			
			$this->res=$this->objFunc->listarCatalogoProyecto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCatalogoProyecto(){
		$this->objFunc=$this->create('MODCatalogoProyecto');	
		if($this->objParam->insertar('id_catalogo_proyecto')){
			$this->res=$this->objFunc->insertarCatalogoProyecto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCatalogoProyecto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCatalogoProyecto(){
			$this->objFunc=$this->create('MODCatalogoProyecto');	
		$this->res=$this->objFunc->eliminarCatalogoProyecto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>