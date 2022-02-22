<?php
/**
*@package pXP
*@file gen-ACTObjetoGasto.php
*@author  (franklin.espinoza)
*@date 30-08-2017 13:18:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTObjetoGasto extends ACTbase{    
			
	function listarObjetoGasto(){

		$this->objParam->defecto('ordenacion','id_objeto_gasto');
		$this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("obj_gas.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObjetoGasto','listarObjetoGasto');
		} else{
			$this->objFunc=$this->create('MODObjetoGasto');
			
			$this->res=$this->objFunc->listarObjetoGasto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarObjetoGasto(){
		$this->objFunc=$this->create('MODObjetoGasto');	
		if($this->objParam->insertar('id_objeto_gasto')){
			$this->res=$this->objFunc->insertarObjetoGasto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarObjetoGasto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarObjetoGasto(){
			$this->objFunc=$this->create('MODObjetoGasto');
		$this->res=$this->objFunc->eliminarObjetoGasto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function clonarObjetoGasto(){
        $this->objFunc=$this->create('MODObjetoGasto');
        $this->res=$this->objFunc->clonarObjetoGasto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>