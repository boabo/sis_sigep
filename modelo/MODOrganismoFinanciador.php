<?php
/**
*@package pXP
*@file gen-MODOrganismoFinanciador.php
*@author  (franklin.espinoza)
*@date 30-08-2017 15:25:07
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODOrganismoFinanciador extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarOrganismoFinanciador(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_organismo_financiador_sel';
		$this->transaccion='SIGEP_ORG_FIN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_organismo_financiador','int4');
		$this->captura('id_cp_organismo_fin','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('desc_organismo','varchar');
		$this->captura('sigla_organismo','varchar');
		$this->captura('organismo','int4');
		$this->captura('id_organismo','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','int4');
		$this->captura('id_gestion','int4');
		$this->captura('desc_organismo_fin','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarOrganismoFinanciador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_organismo_financiador_ime';
		$this->transaccion='SIGEP_ORG_FIN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desc_organismo','desc_organismo','varchar');
		$this->setParametro('sigla_organismo','sigla_organismo','varchar');
		$this->setParametro('organismo','organismo','int4');
		$this->setParametro('id_organismo','id_organismo','int4');
		$this->setParametro('id_cp_organismo_fin','id_cp_organismo_fin','int4');
		$this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarOrganismoFinanciador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_organismo_financiador_ime';
		$this->transaccion='SIGEP_ORG_FIN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_organismo_financiador','id_organismo_financiador','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desc_organismo','desc_organismo','varchar');
		$this->setParametro('sigla_organismo','sigla_organismo','varchar');
		$this->setParametro('organismo','organismo','int4');
		$this->setParametro('id_organismo','id_organismo','int4');
		$this->setParametro('id_cp_organismo_fin','id_cp_organismo_fin','int4');
		$this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarOrganismoFinanciador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_organismo_financiador_ime';
		$this->transaccion='SIGEP_ORG_FIN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_organismo_financiador','id_organismo_financiador','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>