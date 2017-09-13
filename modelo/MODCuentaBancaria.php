<?php
/**
*@package pXP
*@file gen-MODCuentaBancaria.php
*@author  (franklin.espinoza)
*@date 08-09-2017 13:42:27
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaBancaria extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_cuenta_bancaria_sel';
		$this->transaccion='SIGEP_CUEN_BAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('id_cuenta_bancaria_boa','int4');
		$this->captura('banco','int4');
		$this->captura('cuenta','varchar');
		$this->captura('desc_cuenta','varchar');
		$this->captura('moneda','int4');
		$this->captura('tipo_cuenta','bpchar');
		$this->captura('estado_cuenta','bpchar');

		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_reg','int4');
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
			
	function insertarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_bancaria_ime';
		$this->transaccion='SIGEP_CUEN_BAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion


		$this->setParametro('banco','banco','int4');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('desc_cuenta','desc_cuenta','varchar');
		$this->setParametro('moneda','moneda','int4');
		$this->setParametro('tipo_cuenta','tipo_cuenta','bpchar');
		$this->setParametro('estado_cuenta','estado_cuenta','bpchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');



		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_bancaria_ime';
		$this->transaccion='SIGEP_CUEN_BAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_cuenta_bancaria_boa','id_cuenta_bancaria_boa','int4');
		$this->setParametro('desc_cuenta','desc_cuenta','varchar');
		$this->setParametro('moneda','moneda','int4');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('tipo_cuenta','tipo_cuenta','bpchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado_cuenta','estado_cuenta','bpchar');
		$this->setParametro('banco','banco','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_bancaria_ime';
		$this->transaccion='SIGEP_CUEN_BAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria_boa','id_cuenta_bancaria_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>