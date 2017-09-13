<?php
/**
*@package pXP
*@file gen-MODClaseGastoCip.php
*@author  (franklin.espinoza)
*@date 07-09-2017 15:28:46
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODClaseGastoCip extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarClaseGastoCip(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_clase_gasto_cip_sel';
		$this->transaccion='SIGEP_GAS_CIP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_clase_gasto_cip','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('desc_clase_gasto','varchar');
		$this->captura('id_clase_gasto','int4');
		$this->captura('clase_gasto','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_clase_gas','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarClaseGastoCip(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_clase_gasto_cip_ime';
		$this->transaccion='SIGEP_GAS_CIP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desc_clase_gasto','desc_clase_gasto','varchar');
		$this->setParametro('id_clase_gasto','id_clase_gasto','int4');
		$this->setParametro('clase_gasto','clase_gasto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarClaseGastoCip(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_clase_gasto_cip_ime';
		$this->transaccion='SIGEP_GAS_CIP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_clase_gasto_cip','id_clase_gasto_cip','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desc_clase_gasto','desc_clase_gasto','varchar');
		$this->setParametro('id_clase_gasto','id_clase_gasto','int4');
		$this->setParametro('clase_gasto','clase_gasto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarClaseGastoCip(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_clase_gasto_cip_ime';
		$this->transaccion='SIGEP_GAS_CIP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_clase_gasto_cip','id_clase_gasto_cip','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>