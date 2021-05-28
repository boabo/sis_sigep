<?php
/**
*@package pXP
*@file gen-MODFuenteFinanciamiento.php
*@author  (franklin.espinoza)
*@date 30-08-2017 15:54:19
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFuenteFinanciamiento extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFuenteFinanciamiento(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_fuente_financiamiento_sel';
		$this->transaccion='SIGEP_FUE_FIN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_fuente_financiamiento','int4');
		$this->captura('id_cp_fuente_fin','int4');
		$this->captura('id_gestion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('fuente','int4');
		$this->captura('sigla_fuente','varchar');
		$this->captura('desc_fuente','varchar');
		$this->captura('id_fuente','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','int4');
		$this->captura('desc_fuente_fin','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFuenteFinanciamiento(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_fuente_financiamiento_ime';
		$this->transaccion='SIGEP_FUE_FIN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fuente','fuente','int4');
		$this->setParametro('id_cp_fuente_fin','id_cp_fuente_fin','int4');
		$this->setParametro('sigla_fuente','sigla_fuente','varchar');
		$this->setParametro('desc_fuente','desc_fuente','varchar');
		$this->setParametro('id_fuente','id_fuente','int4');
		$this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFuenteFinanciamiento(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_fuente_financiamiento_ime';
		$this->transaccion='SIGEP_FUE_FIN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fuente_financiamiento','id_fuente_financiamiento','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fuente','fuente','int4');
		$this->setParametro('sigla_fuente','sigla_fuente','varchar');
		$this->setParametro('desc_fuente','desc_fuente','varchar');
		$this->setParametro('id_fuente','id_fuente','int4');
		$this->setParametro('id_cp_fuente_fin','id_cp_fuente_fin','int4');
		$this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFuenteFinanciamiento(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_fuente_financiamiento_ime';
		$this->transaccion='SIGEP_FUE_FIN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fuente_financiamiento','id_fuente_financiamiento','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    /**{developer:franklin.espinoza, date:18/01/2021, description: Clonar Fuente Financiamiento}**/
    function clonarFuenteFinanciamiento(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_fuente_financiamiento_ime';
        $this->transaccion='PRE_CLO_FUE_FIN_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_fuente_financiamiento','id_fuente_financiamiento','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    /**{developer:franklin.espinoza, date:18/01/2021, description: Clonar Fuente Financiamiento}**/
			
}
?>