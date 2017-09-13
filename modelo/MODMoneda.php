<?php
/**
*@package pXP
*@file gen-MODMoneda.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:21:25
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODMoneda extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarMoneda(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_moneda_sel';
		$this->transaccion='SIGEP_MONEDA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_moneda_boa','int4');
		$this->captura('moneda','int4');
		$this->captura('pais','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('desc_moneda','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_mon','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarMoneda(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_moneda_ime';
		$this->transaccion='SIGEP_MONEDA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('moneda','moneda','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('desc_moneda','desc_moneda','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('pais','pais','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarMoneda(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_moneda_ime';
		$this->transaccion='SIGEP_MONEDA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_moneda_boa','id_moneda_boa','int4');
		$this->setParametro('moneda','moneda','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('desc_moneda','desc_moneda','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('pais','pais','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarMoneda(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_moneda_ime';
		$this->transaccion='SIGEP_MONEDA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_moneda_boa','id_moneda_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>