<?php
/**
*@package pXP
*@file gen-ACTOrganismoFinanciador.php
*@author  (franklin.espinoza)
*@date 30-08-2017 15:25:07
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTOrganismoFinanciador extends ACTbase{    
			
	function listarOrganismoFinanciador(){
		$this->objParam->defecto('ordenacion','id_organismo_financiador');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODOrganismoFinanciador','listarOrganismoFinanciador');
		} else{
			$this->objFunc=$this->create('MODOrganismoFinanciador');
			
			$this->res=$this->objFunc->listarOrganismoFinanciador($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarOrganismoFinanciador(){
		$this->objFunc=$this->create('MODOrganismoFinanciador');	
		if($this->objParam->insertar('id_organismo_financiador')){
			$this->res=$this->objFunc->insertarOrganismoFinanciador($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarOrganismoFinanciador($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarOrganismoFinanciador(){
			$this->objFunc=$this->create('MODOrganismoFinanciador');	
		$this->res=$this->objFunc->eliminarOrganismoFinanciador($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>