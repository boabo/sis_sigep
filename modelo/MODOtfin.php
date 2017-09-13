<?php
/**
*@package pXP
*@file gen-MODOtfin.php
*@author  (franklin.espinoza)
*@date 07-09-2017 18:59:47
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODOtfin extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarOtfin(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_otfin_sel';
		$this->transaccion='SIGEP_OTFIN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_otfin','int4');
		$this->captura('otfin','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_entidad','int4');
		$this->captura('desc_otfin','varchar');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarOtfin(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_otfin_ime';
		$this->transaccion='SIGEP_OTFIN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('otfin','otfin','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('desc_otfin','desc_otfin','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarOtfin(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_otfin_ime';
		$this->transaccion='SIGEP_OTFIN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_otfin','id_otfin','int4');
		$this->setParametro('otfin','otfin','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('desc_otfin','desc_otfin','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarOtfin(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_otfin_ime';
		$this->transaccion='SIGEP_OTFIN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_otfin','id_otfin','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>