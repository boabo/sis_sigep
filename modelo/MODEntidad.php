<?php
/**
*@package pXP
*@file gen-MODEntidad.php
*@author  (franklin.espinoza)
*@date 30-08-2017 15:54:21
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEntidad extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEntidad(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_entidad_sel';
		$this->transaccion='SIGEP_ENT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_entidad_boa','int4');
		$this->captura('id_institucion','int4');
		$this->captura('tuicion_entidad','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('sigla_entidad','varchar');
		$this->captura('entidad','int4');
		$this->captura('desc_entidad','varchar');
		$this->captura('id_entidad','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_institucion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarEntidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_entidad_ime';
		$this->transaccion='SIGEP_ENT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('tuicion_entidad','tuicion_entidad','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('sigla_entidad','sigla_entidad','varchar');
		$this->setParametro('entidad','entidad','int4');
		$this->setParametro('desc_entidad','desc_entidad','varchar');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('id_institucion','id_institucion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEntidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_entidad_ime';
		$this->transaccion='SIGEP_ENT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entidad_boa','id_entidad_boa','int4');
		$this->setParametro('tuicion_entidad','tuicion_entidad','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('sigla_entidad','sigla_entidad','varchar');
		$this->setParametro('entidad','entidad','int4');
		$this->setParametro('desc_entidad','desc_entidad','varchar');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('id_institucion','id_institucion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEntidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_entidad_ime';
		$this->transaccion='SIGEP_ENT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entidad_boa','id_entidad_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>