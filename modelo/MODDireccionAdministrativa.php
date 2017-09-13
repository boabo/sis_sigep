<?php
/**
*@package pXP
*@file gen-MODDireccionAdministrativa.php
*@author  (franklin.espinoza)
*@date 06-09-2017 15:01:48
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDireccionAdministrativa extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDireccionAdministrativa(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_direccion_administrativa_sel';
		$this->transaccion='SIGEP_DIR_ADM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_direccion_administrativa_boa','int4');
		$this->captura('id_direccion_administrativa','int4');
		$this->captura('id_gestion','int4');
		$this->captura('id_da','int4');
		$this->captura('tipo_da','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('da','int4');
		$this->captura('id_entidad','int4');
		$this->captura('desc_da','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','int4');
		$this->captura('desc_direccion_admin','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDireccionAdministrativa(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_direccion_administrativa_ime';
		$this->transaccion='SIGEP_DIR_ADM_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_direccion_administrativa','id_direccion_administrativa','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_da','id_da','int4');
		$this->setParametro('tipo_da','tipo_da','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('da','da','int4');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('desc_da','desc_da','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDireccionAdministrativa(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_direccion_administrativa_ime';
		$this->transaccion='SIGEP_DIR_ADM_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_direccion_administrativa_boa','id_direccion_administrativa_boa','int4');
		$this->setParametro('id_direccion_administrativa','id_direccion_administrativa','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_da','id_da','int4');
		$this->setParametro('tipo_da','tipo_da','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('da','da','int4');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('desc_da','desc_da','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDireccionAdministrativa(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_direccion_administrativa_ime';
		$this->transaccion='SIGEP_DIR_ADM_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_direccion_administrativa_boa','id_direccion_administrativa_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>