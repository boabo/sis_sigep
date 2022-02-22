<?php
/**
*@package pXP
*@file gen-MODObjetoGasto.php
*@author  (franklin.espinoza)
*@date 30-08-2017 13:18:08
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODObjetoGasto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarObjetoGasto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_objeto_gasto_sel';
		$this->transaccion='SIGEP_OBJ_GAS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_objeto_gasto','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_gestion','int4');
		$this->captura('desc_objeto','varchar');
		$this->captura('nivel','varchar');
		$this->captura('objeto','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_objeto','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo','varchar');
		$this->captura('nombre_partida','varchar');
		$this->captura('gestion','integer');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarObjetoGasto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_objeto_gasto_ime';
		$this->transaccion='SIGEP_OBJ_GAS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('desc_objeto','desc_objeto','varchar');
		$this->setParametro('nivel','nivel','varchar');
		$this->setParametro('objeto','objeto','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_objeto','id_objeto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarObjetoGasto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_objeto_gasto_ime';
		$this->transaccion='SIGEP_OBJ_GAS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_objeto_gasto','id_objeto_gasto','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('desc_objeto','desc_objeto','varchar');
		$this->setParametro('nivel','nivel','varchar');
		$this->setParametro('objeto','objeto','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_objeto','id_objeto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarObjetoGasto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_objeto_gasto_ime';
		$this->transaccion='SIGEP_OBJ_GAS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_objeto_gasto','id_objeto_gasto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function clonarObjetoGasto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_objeto_gasto_ime';
        $this->transaccion='SIGEP_CLONAR_OBJ_GAS';
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