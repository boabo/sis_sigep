<?php
/**
*@package pXP
*@file gen-MODBanco.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:37:46
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODBanco extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarBanco(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_banco_sel';
		$this->transaccion='SIGEP_BANCO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_banco_boa','int4');
		$this->captura('banco','int4');
		$this->captura('id_institucion','int4');
		$this->captura('desc_banco','varchar');
		$this->captura('spt','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_institucion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarBanco(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_banco_ime';
		$this->transaccion='SIGEP_BANCO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('banco','banco','int4');
		$this->setParametro('spt','spt','varchar');
		$this->setParametro('id_institucion','id_institucion','int4');
		$this->setParametro('desc_banco','desc_banco','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarBanco(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_banco_ime';
		$this->transaccion='SIGEP_BANCO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banco_boa','id_banco_boa','int4');
		$this->setParametro('banco','banco','int4');
		$this->setParametro('id_institucion','id_institucion','int4');
		$this->setParametro('desc_banco','desc_banco','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('spt','spt','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarBanco(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_banco_ime';
		$this->transaccion='SIGEP_BANCO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banco_boa','id_banco_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>