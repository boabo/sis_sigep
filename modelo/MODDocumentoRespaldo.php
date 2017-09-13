<?php
/**
*@package pXP
*@file gen-MODDocumentoRespaldo.php
*@author  (franklin.espinoza)
*@date 07-09-2017 15:11:16
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDocumentoRespaldo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDocumentoRespaldo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_documento_respaldo_sel';
		$this->transaccion='SIGEP_DOC_RESP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_documento_respaldo','int4');
		$this->captura('documento_respaldo','int4');
		$this->captura('desc_documento','varchar');
		$this->captura('sigla','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
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
			
	function insertarDocumentoRespaldo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_documento_respaldo_ime';
		$this->transaccion='SIGEP_DOC_RESP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('documento_respaldo','documento_respaldo','int4');
		$this->setParametro('desc_documento','desc_documento','varchar');
		$this->setParametro('sigla','sigla','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDocumentoRespaldo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_documento_respaldo_ime';
		$this->transaccion='SIGEP_DOC_RESP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_documento_respaldo','id_documento_respaldo','int4');
		$this->setParametro('documento_respaldo','documento_respaldo','int4');
		$this->setParametro('desc_documento','desc_documento','varchar');
		$this->setParametro('sigla','sigla','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDocumentoRespaldo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_documento_respaldo_ime';
		$this->transaccion='SIGEP_DOC_RESP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_documento_respaldo','id_documento_respaldo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>