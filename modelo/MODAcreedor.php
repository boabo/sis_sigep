<?php
/**
*@package pXP
*@file gen-MODAcreedor.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:04:47
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAcreedor extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAcreedor(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_acreedor_sel';
		$this->transaccion='SIGEP_ACREE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_acreedor','int4');
		$this->captura('acreedor','int4');
		$this->captura('id_afp','int4');
		$this->captura('de_ley','varchar');
		$this->captura('desc_acreedor','varchar');
		$this->captura('tipo_acreedor','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_tipo_obligacion_columna','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_obligacion_col','varchar');
		$this->captura('desc_afp','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		//var_dump($this->consulta);exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAcreedor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_acreedor_ime';
		$this->transaccion='SIGEP_ACREE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('acreedor','acreedor','int4');
		$this->setParametro('id_afp','id_afp','int4');
		$this->setParametro('de_ley','de_ley','varchar');
		$this->setParametro('desc_acreedor','desc_acreedor','varchar');
		$this->setParametro('tipo_acreedor','tipo_acreedor','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_obligacion_columna','id_tipo_obligacion_columna','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAcreedor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_acreedor_ime';
		$this->transaccion='SIGEP_ACREE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_acreedor','id_acreedor','int4');
		$this->setParametro('acreedor','acreedor','int4');
		$this->setParametro('id_afp','id_afp','int4');
		$this->setParametro('de_ley','de_ley','varchar');
		$this->setParametro('desc_acreedor','desc_acreedor','varchar');
		$this->setParametro('tipo_acreedor','tipo_acreedor','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_obligacion_columna','id_tipo_obligacion_columna','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAcreedor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_acreedor_ime';
		$this->transaccion='SIGEP_ACREE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_acreedor','id_acreedor','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarObligacionColumna(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_acreedor_sel';
		$this->transaccion='SIGEP_OB_COL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_obligacion_columna','int4');
		$this->captura('codigo_columna','varchar');
		$this->captura('id_tipo_obligacion','int4');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>