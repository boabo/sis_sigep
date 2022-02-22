<?php
/**
*@package pXP
*@file gen-ACTProyectoActividad.php
*@author  (franklin.espinoza)
*@date 06-09-2017 21:27:18
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProyectoActividad extends ACTbase{    
			
	function listarProyectoActividad(){
		$this->objParam->defecto('ordenacion','id_proyecto_actividad');
		$this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("pro_act.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoActividad','listarProyectoActividad');
		} else{
			$this->objFunc=$this->create('MODProyectoActividad');
			
			$this->res=$this->objFunc->listarProyectoActividad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarProyectoActividad(){
		$this->objFunc=$this->create('MODProyectoActividad');	
		if($this->objParam->insertar('id_proyecto_actividad')){ //var_dump('insertar');exit;
			$this->res=$this->objFunc->insertarProyectoActividad($this->objParam);			
		} else{ //var_dump('modificar');exit;
			$this->res=$this->objFunc->modificarProyectoActividad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarProyectoActividad(){
			$this->objFunc=$this->create('MODProyectoActividad');	
		$this->res=$this->objFunc->eliminarProyectoActividad($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    /**{developer:franklin.espinoza, date:18/01/2021, description: Clonar Proyecto Actividad}**/
    /*function clonarProyectoActividad(){
        $this->objFunc=$this->create('MODProyectoActividad');
        $this->res=$this->objFunc->clonarProyectoActividad($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }*/
    /**{developer:franklin.espinoza, date:18/01/2021, description: Clonar Proyecto Actividad}**/

    /**{developer:franklin.espinoza, date:05/01/2022, description: Clonar Proyecto Actividad Gestion}**/
    function clonarProyectoActividad(){
        $this->objFunc=$this->create('MODProyectoActividad');
        $this->res=$this->objFunc->clonarProyectoActividad($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    /**{developer:franklin.espinoza, date:05/01/2022, description: Clonar Proyecto Actividad Gestion}**/
			
}

?>