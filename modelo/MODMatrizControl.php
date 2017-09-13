<?php
/**
*@package pXP
*@file gen-MODMatrizControl.php
*@author  (franklin.espinoza)
*@date 08-09-2017 18:56:26
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODMatrizControl extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarMatrizControl(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_matriz_control_sel';
		$this->transaccion='SIGEP_MAT_CONT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_matriz_control','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_libreta','int4');
		$this->captura('libreta','varchar');
		$this->captura('cuenta','varchar');
		$this->captura('banco','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarMatrizControl(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_matriz_control_ime';
		$this->transaccion='SIGEP_MAT_CONT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_libreta','id_libreta','int4');
		$this->setParametro('libreta','libreta','varchar');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('banco','banco','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarMatrizControl(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_matriz_control_ime';
		$this->transaccion='SIGEP_MAT_CONT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_matriz_control','id_matriz_control','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_libreta','id_libreta','int4');
		$this->setParametro('libreta','libreta','varchar');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('banco','banco','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarMatrizControl(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_matriz_control_ime';
		$this->transaccion='SIGEP_MAT_CONT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_matriz_control','id_matriz_control','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>