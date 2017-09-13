<?php
/**
*@package pXP
*@file gen-MODSigade.php
*@author  (franklin.espinoza)
*@date 07-09-2017 18:46:18
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODSigade extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarSigade(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_sigade_sel';
		$this->transaccion='SIGEP_SIGAD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_sigade','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('desc_sigade','varchar');
		$this->captura('tipo_deuda','varchar');
		$this->captura('sigade','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
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
			
	function insertarSigade(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_sigade_ime';
		$this->transaccion='SIGEP_SIGAD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desc_sigade','desc_sigade','varchar');
		$this->setParametro('tipo_deuda','tipo_deuda','varchar');
		$this->setParametro('sigade','sigade','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarSigade(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_sigade_ime';
		$this->transaccion='SIGEP_SIGAD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_sigade','id_sigade','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desc_sigade','desc_sigade','varchar');
		$this->setParametro('tipo_deuda','tipo_deuda','varchar');
		$this->setParametro('sigade','sigade','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarSigade(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_sigade_ime';
		$this->transaccion='SIGEP_SIGAD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_sigade','id_sigade','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>