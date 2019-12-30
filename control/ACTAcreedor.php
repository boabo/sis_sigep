<?php
/**
*@package pXP
*@file gen-ACTAcreedor.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:04:47
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAcreedor extends ACTbase{    
			
	function listarAcreedor(){
		$this->objParam->defecto('ordenacion','id_acreedor');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAcreedor','listarAcreedor');
		} else{
			$this->objFunc=$this->create('MODAcreedor');
			
			$this->res=$this->objFunc->listarAcreedor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAcreedor(){
		$this->objFunc=$this->create('MODAcreedor');	
		if($this->objParam->insertar('id_acreedor')){
			$this->res=$this->objFunc->insertarAcreedor($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAcreedor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAcreedor(){
			$this->objFunc=$this->create('MODAcreedor');	
		$this->res=$this->objFunc->eliminarAcreedor($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarTipoColumna(){

		if ($this->objParam->getParametro('retencion') != '') {
			$this->objParam->addFiltro("tto.retencion = ''". $this->objParam->getParametro('retencion')."''");
		}

		$this->objFunc=$this->create('MODAcreedor');
		$this->res=$this->objFunc->listarTipoColumna($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>