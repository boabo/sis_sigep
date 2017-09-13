<?php
/**
*@package pXP
*@file gen-MODPresupuestoGasto.php
*@author  (franklin.espinoza)
*@date 06-09-2017 21:27:23
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPresupuestoGasto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPresupuestoGasto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_presupuesto_gasto_sel';
		$this->transaccion='SIGEP_PRE_GAS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_presupuesto_gasto','int4');
		$this->captura('gestion','int4');
		$this->captura('id_ue','int4');
		$this->captura('id_catpry','int4');
		$this->captura('id_gestion','int4');
		$this->captura('id_organismo','int4');
		$this->captura('ppto_inicial','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('credito_disponible','numeric');
		$this->captura('id_catprg','int4');
		$this->captura('id_fuente','int4');
		$this->captura('id_ent_transferencia','int4');
		$this->captura('id_ptogto','int4');
		$this->captura('id_da','int4');
		$this->captura('id_objeto','int4');
		$this->captura('id_entidad','int4');
		$this->captura('ppto_vigente','numeric');
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
			
	function insertarPresupuestoGasto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_presupuesto_gasto_ime';
		$this->transaccion='SIGEP_PRE_GAS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('gestion','gestion','int4');
		$this->setParametro('id_ue','id_ue','int4');
		$this->setParametro('id_catpry','id_catpry','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_organismo','id_organismo','int4');
		$this->setParametro('ppto_inicial','ppto_inicial','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('credito_disponible','credito_disponible','numeric');
		$this->setParametro('id_catprg','id_catprg','int4');
		$this->setParametro('id_fuente','id_fuente','int4');
		$this->setParametro('id_ent_transferencia','id_ent_transferencia','int4');
		$this->setParametro('id_ptogto','id_ptogto','int4');
		$this->setParametro('id_da','id_da','int4');
		$this->setParametro('id_objeto','id_objeto','int4');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('ppto_vigente','ppto_vigente','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPresupuestoGasto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_presupuesto_gasto_ime';
		$this->transaccion='SIGEP_PRE_GAS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto_gasto','id_presupuesto_gasto','int4');
		$this->setParametro('gestion','gestion','int4');
		$this->setParametro('id_ue','id_ue','int4');
		$this->setParametro('id_catpry','id_catpry','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_organismo','id_organismo','int4');
		$this->setParametro('ppto_inicial','ppto_inicial','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('credito_disponible','credito_disponible','numeric');
		$this->setParametro('id_catprg','id_catprg','int4');
		$this->setParametro('id_fuente','id_fuente','int4');
		$this->setParametro('id_ent_transferencia','id_ent_transferencia','int4');
		$this->setParametro('id_ptogto','id_ptogto','int4');
		$this->setParametro('id_da','id_da','int4');
		$this->setParametro('id_objeto','id_objeto','int4');
		$this->setParametro('id_entidad','id_entidad','int4');
		$this->setParametro('ppto_vigente','ppto_vigente','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPresupuestoGasto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_presupuesto_gasto_ime';
		$this->transaccion='SIGEP_PRE_GAS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto_gasto','id_presupuesto_gasto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>