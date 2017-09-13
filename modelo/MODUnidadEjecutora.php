<?php
/**
*@package pXP
*@file gen-MODUnidadEjecutora.php
*@author  (franklin.espinoza)
*@date 06-09-2017 20:53:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODUnidadEjecutora extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarUnidadEjecutora(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_unidad_ejecutora_sel';
		$this->transaccion='SIGEP_UNI_EJE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_ejecutora_boa','int4');
		$this->captura('ue','int4');
		$this->captura('desc_ue','varchar');
		$this->captura('id_da','int4');
		$this->captura('id_unidad_ejecutora','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('id_ue','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','int4');
		$this->captura('desc_unidad_ejec','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarUnidadEjecutora(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_unidad_ejecutora_ime';
		$this->transaccion='SIGEP_UNI_EJE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('ue','ue','int4');
		$this->setParametro('desc_ue','desc_ue','varchar');
		$this->setParametro('id_da','id_da','int4');
		$this->setParametro('id_unidad_ejecutora','id_unidad_ejecutora','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_ue','id_ue','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarUnidadEjecutora(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_unidad_ejecutora_ime';
		$this->transaccion='SIGEP_UNI_EJE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_ejecutora_boa','id_unidad_ejecutora_boa','int4');
		$this->setParametro('ue','ue','int4');
		$this->setParametro('desc_ue','desc_ue','varchar');
		$this->setParametro('id_da','id_da','int4');
		$this->setParametro('id_unidad_ejecutora','id_unidad_ejecutora','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_ue','id_ue','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarUnidadEjecutora(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_unidad_ejecutora_ime';
		$this->transaccion='SIGEP_UNI_EJE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_ejecutora_boa','id_unidad_ejecutora_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>