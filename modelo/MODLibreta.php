<?php
/**
*@package pXP
*@file gen-MODLibreta.php
*@author  (franklin.espinoza)
*@date 08-09-2017 14:59:30
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODLibreta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarLibreta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_libreta_sel';
		$this->transaccion='SIGEP_LIBRETA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_libreta_boa','int4');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('moneda','int4');
		$this->captura('banco','int4');
		$this->captura('estado_libre','bpchar');
		$this->captura('desc_libreta','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_libreta','int4');
		$this->captura('libreta','varchar');
		$this->captura('cuenta','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cuenta_banco','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarLibreta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_libreta_ime';
		$this->transaccion='SIGEP_LIBRETA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('moneda','moneda','int4');
		$this->setParametro('banco','banco','int4');
		$this->setParametro('estado_libre','estado_libre','bpchar');
		$this->setParametro('desc_libreta','desc_libreta','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_libreta','id_libreta','int4');
		$this->setParametro('libreta','libreta','varchar');
		$this->setParametro('cuenta','cuenta','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarLibreta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_libreta_ime';
		$this->transaccion='SIGEP_LIBRETA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_libreta_boa','id_libreta_boa','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('moneda','moneda','int4');
		$this->setParametro('banco','banco','int4');
		$this->setParametro('estado_libre','estado_libre','bpchar');
		$this->setParametro('desc_libreta','desc_libreta','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_libreta','id_libreta','int4');
		$this->setParametro('libreta','libreta','varchar');
		$this->setParametro('cuenta','cuenta','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarLibreta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_libreta_ime';
		$this->transaccion='SIGEP_LIBRETA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_libreta_boa','id_libreta_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>