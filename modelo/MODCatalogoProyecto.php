<?php
/**
*@package pXP
*@file gen-MODCatalogoProyecto.php
*@author  (franklin.espinoza)
*@date 06-09-2017 21:31:34
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCatalogoProyecto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCatalogoProyecto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_catalogo_proyecto_sel';
		$this->transaccion='SIGEP_CAT_PRO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_catalogo_proyecto','int4');
		$this->captura('id_cp_proyecto','int4');
		$this->captura('id_catpry','int4');
		$this->captura('sisin','varchar');
		$this->captura('desc_catpry','varchar');
		$this->captura('id_entidad','int4');
		$this->captura('id_gestion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_catprg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','int4');
		$this->captura('desc_proyecto','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCatalogoProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_catalogo_proyecto_ime';
		$this->transaccion='SIGEP_CAT_PRO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cp_proyecto','id_cp_proyecto','int4');
		$this->setParametro('id_catpry','id_catpry','int4');
		$this->setParametro('sisin','sisin','varchar');
		$this->setParametro('desc_catpry','desc_catpry','varchar');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_catprg','id_catprg','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCatalogoProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_catalogo_proyecto_ime';
		$this->transaccion='SIGEP_CAT_PRO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_catalogo_proyecto','id_catalogo_proyecto','int4');
		$this->setParametro('id_cp_proyecto','id_cp_proyecto','int4');
		$this->setParametro('id_catpry','id_catpry','int4');
		$this->setParametro('sisin','sisin','varchar');
		$this->setParametro('desc_catpry','desc_catpry','varchar');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_catprg','id_catprg','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCatalogoProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_catalogo_proyecto_ime';
		$this->transaccion='SIGEP_CAT_PRO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_catalogo_proyecto','id_catalogo_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>