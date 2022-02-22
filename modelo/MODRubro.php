<?php
/**
 *@package pXP
 *@file gen-MODRubro.php
 *@author  (vladimir.gutierrez,ruben.guancollo)
 *@date 05-08-2021 15:18:08
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODRubro extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarRubro(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='sigep.ft_rubro_sel';
        $this->transaccion='SIGEP_RUB_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        /*	$this->captura('id_rubro','int4');
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
            $this->captura('gestion','integer');*/

        $this->captura('id_recurso_rubro','int4');
        $this->captura('id_partida','int4');
        $this->captura('id_gestion','integer');
        $this->captura('desc_rubro','varchar');
        $this->captura('nivel','varchar');
        $this->captura('rubro','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('id_rubro','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
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

    function insertarRubro(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_rubro_ime';
        $this->transaccion='SIGEP_RUB_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_recurso_rubro','id_recurso_rubro','int4');
        $this->setParametro('id_partida','id_partida','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('desc_rubro','desc_rubro','varchar');
        $this->setParametro('nivel','nivel','varchar');
        $this->setParametro('rubro','rubro','varchar');
        //$this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_rubro','id_rubro','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarRubro(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_rubro_ime';
        $this->transaccion='SIGEP_RUB_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_recurso_rubro','id_recurso_rubro','int4');
        $this->setParametro('id_partida','id_partida','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('desc_rubro','desc_rubro','varchar');
        $this->setParametro('nivel','nivel','varchar');
        $this->setParametro('rubro','rubro','varchar');
        //$this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_rubro','id_rubro','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarRubro(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_rubro_ime';
        $this->transaccion='SIGEP_RUB_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_recurso_rubro','id_recurso_rubro','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>