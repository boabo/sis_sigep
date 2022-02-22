<?php
/**
*@package pXP
*@file gen-ACTCuentaContable.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:53:56
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaContable extends ACTbase{    
			
	function listarCuentaContable(){
		$this->objParam->defecto('ordenacion','id_cuenta_contable');
		$this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("cue_cont.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaContable','listarCuentaContable');
		} else{
			$this->objFunc=$this->create('MODCuentaContable');
			
			$this->res=$this->objFunc->listarCuentaContable($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaContable(){
		$this->objFunc=$this->create('MODCuentaContable');	
		if($this->objParam->insertar('id_cuenta_contable')){
			$this->res=$this->objFunc->insertarCuentaContable($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaContable($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaContable(){
			$this->objFunc=$this->create('MODCuentaContable');	
		$this->res=$this->objFunc->eliminarCuentaContable($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function clonarCuentaContable(){
        $this->objFunc=$this->create('MODCuentaContable');
        $this->res=$this->objFunc->clonarCuentaContable($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>