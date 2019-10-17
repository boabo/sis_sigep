<?php
/**
 *@package pXP
 *@file gen-MODDocumentoRespaldo.php
 *@author  (franklin.espinoza)
 *@date 07-09-2017 15:11:16
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODMulta extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarMulta(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='sigep.ft_multa_sel';
        $this->transaccion='SIGEP_MULTA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_multa','int4');
        $this->captura('codigo','varchar');
        $this->captura('desc_multa','varchar');
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

    function insertarMulta(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_multa_ime';
        $this->transaccion='SIGEP_MULTA_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('desc_multa','desc_multa','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarMulta(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_multa_ime';
        $this->transaccion='SIGEP_MULTA_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_multa','id_multa','int4');
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('desc_multa','desc_multa','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarMulta(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_multa_ime';
        $this->transaccion='SIGEP_MULTA_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_multa','id_multa','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>