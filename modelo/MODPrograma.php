<?php
/**
*@package pXP
*@file gen-MODPrograma.php
*@author  (franklin.espinoza)
*@date 06-09-2017 20:53:14
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPrograma extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPrograma(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_programa_sel';
		$this->transaccion='SIGEP_PRO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_programa_boa','int4');
		$this->captura('id_cp_programa','int4');
		$this->captura('id_gestion','int4');
		$this->captura('programa','int4');
		$this->captura('desc_catprg','varchar');
		$this->captura('id_entidad','int4');
		$this->captura('nivel','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_catprg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','int4');
		$this->captura('desc_programa','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPrograma(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_programa_ime';
		$this->transaccion='SIGEP_PRO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cp_programa','id_cp_programa','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('programa','programa','int4');
		$this->setParametro('desc_catprg','desc_catprg','varchar');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('nivel','nivel','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_catprg','id_catprg','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPrograma(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_programa_ime';
		$this->transaccion='SIGEP_PRO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_programa_boa','id_programa_boa','int4');
		$this->setParametro('id_cp_programa','id_cp_programa','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('programa','programa','int4');
		$this->setParametro('desc_catprg','desc_catprg','varchar');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('nivel','nivel','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_catprg','id_catprg','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPrograma(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_programa_ime';
		$this->transaccion='SIGEP_PRO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_programa_boa','id_programa_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>