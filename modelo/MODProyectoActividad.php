<?php
/**
*@package pXP
*@file gen-MODProyectoActividad.php
*@author  (franklin.espinoza)
*@date 06-09-2017 21:27:18
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProyectoActividad extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProyectoActividad(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_proyecto_actividad_sel';
		$this->transaccion='SIGEP_PRO_ACT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto_actividad','int4');
		$this->captura('id_programa','int4');
		$this->captura('desc_catprg','varchar');
		$this->captura('id_catprg','int4');
		$this->captura('id_categoria_programatica','int4');
		$this->captura('programa','int4');
		$this->captura('id_entidad','int4');
		$this->captura('proyecto','varchar');
		$this->captura('nivel','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('actividad','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cat_prog','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarProyectoActividad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_proyecto_actividad_ime';
		$this->transaccion='SIGEP_PRO_ACT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_programa','id_programa','int4');
		$this->setParametro('desc_catprg','desc_catprg','varchar');
		$this->setParametro('id_catprg','id_catprg','int4');
		$this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
		$this->setParametro('programa','programa','int4');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('proyecto','proyecto','varchar');
		$this->setParametro('nivel','nivel','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('actividad','actividad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarProyectoActividad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_proyecto_actividad_ime';
		$this->transaccion='SIGEP_PRO_ACT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_actividad','id_proyecto_actividad','int4');
		$this->setParametro('id_programa','id_programa','int4');
		$this->setParametro('desc_catprg','desc_catprg','varchar');
		$this->setParametro('id_catprg','id_catprg','int4');
		$this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
		$this->setParametro('programa','programa','int4');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('proyecto','proyecto','varchar');
		$this->setParametro('nivel','nivel','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('actividad','actividad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProyectoActividad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_proyecto_actividad_ime';
		$this->transaccion='SIGEP_PRO_ACT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_actividad','id_proyecto_actividad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    /**{developer:franklin.espinoza, date:18/01/2021, description: Clonar Proyecto Actividad}**/
    /*function clonarProyectoActividad(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_proyecto_actividad_ime';
        $this->transaccion='PRE_CLO_PRO_ACT_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proyecto_actividad','id_proyecto_actividad','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }*/
    /**{developer:franklin.espinoza, date:18/01/2021, description: Clonar Proyecto Actividad}**/

    /**{developer:franklin.espinoza, date:18/01/2021, description: Clonar Proyecto Actividad}**/
    function clonarProyectoActividad(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_proyecto_actividad_ime';
        $this->transaccion='PRE_CLO_PRO_ACT_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('gestion','gestion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    /**{developer:franklin.espinoza, date:18/01/2021, description: Clonar Proyecto Actividad}**/
			
}
?>