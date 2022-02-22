<?php
/**
*@package pXP
*@file gen-MODCuentaContable.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:53:56
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaContable extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaContable(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_cuenta_contable_sel';
		$this->transaccion='SIGEP_CUE_CONT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_contable','int4');
		$this->captura('des_cuenta_contable','varchar');
		$this->captura('cuenta_contable','varchar');
		$this->captura('imputable','varchar');
		$this->captura('id_cuenta','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('modelo_contable','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cuenta','varchar');
		$this->captura('gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCuentaContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_contable_ime';
		$this->transaccion='SIGEP_CUE_CONT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('des_cuenta_contable','des_cuenta_contable','varchar');
		$this->setParametro('cuenta_contable','cuenta_contable','varchar');
		$this->setParametro('imputable','imputable','varchar');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('modelo_contable','modelo_contable','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_contable_ime';
		$this->transaccion='SIGEP_CUE_CONT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_contable','id_cuenta_contable','int4');
		$this->setParametro('des_cuenta_contable','des_cuenta_contable','varchar');
		$this->setParametro('cuenta_contable','cuenta_contable','varchar');
		$this->setParametro('imputable','imputable','varchar');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('modelo_contable','modelo_contable','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_contable_ime';
		$this->transaccion='SIGEP_CUE_CONT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_contable','id_cuenta_contable','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function clonarCuentaContable(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_cuenta_contable_ime';
        $this->transaccion='SIGEP_CLONAR_CUE_CON';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('gestion','gestion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta(); //echo $this->consulta; exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>