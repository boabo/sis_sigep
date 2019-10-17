<?php
/**
 *@package pXP
 *@file gen-MODSigepAdqDet.php
 *@author  (rzabala)
 *@date 25-03-2019 15:50:47
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODSigepAdqDet extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarSigepAdqDet(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='sigep.ft_sigep_adq_det_sel';
        $this->transaccion='SIGEP_SAD_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_sigep_adq_det','int4');
        $this->captura('id_sigep_adq','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('gestion','int4');
        $this->captura('clase_gasto_cip','varchar');
        $this->captura('moneda','varchar');
        $this->captura('total_autorizado_mo','numeric');
        $this->captura('id_ptogto','int4');
        $this->captura('monto_partida','numeric');
        $this->captura('tipo_doc_rdo','varchar');
        $this->captura('nro_doc_rdo','int4');
        $this->captura('sec_doc_rdo','int4');
        $this->captura('fecha_elaboracion','date');
        $this->captura('justificacion','varchar');
        $this->captura('id_fuente','varchar');
        $this->captura('id_organismo','varchar');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('beneficiario','varchar');
        $this->captura('banco_benef','varchar');
        $this->captura('cuenta_benef','varchar');
        $this->captura('banco_origen','varchar');
        $this->captura('cta_origen','varchar');
        $this->captura('libreta_origen','varchar');
        $this->captura('usuario_apro','varchar');
        $this->captura('monto_benef','numeric');
        $this->captura('multa','numeric');
        $this->captura('retencion','numeric');
        $this->captura('liquido_pagable','numeric');
        $this->captura('cuenta_contable','varchar');
        $this->captura('sisin','varchar');
        $this->captura('otfin','varchar');
        $this->captura('usuario_firm','varchar');
        $this->captura('cod_multa','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    /*function listarSigepAdqDet(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='sigep.ft_sigep_adq_det_sel';
        $this->transaccion='SIGEP_SAD_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_sigep_adq_det','int4');
        $this->captura('id_sigep_adq','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('gestion','int4');
        $this->captura('clase_gasto_cip','int4');
        $this->captura('moneda','int4');
        $this->captura('total_autorizado_mo','numeric');
        $this->captura('id_ptogto','int4');
        $this->captura('monto_partida','numeric');
        $this->captura('tipo_doc_rdo','int4');
        $this->captura('nro_doc_rdo','int4');
        $this->captura('sec_doc_rdo','int4');
        $this->captura('fecha_elaboracion','date');
        $this->captura('justificacion','varchar');
        $this->captura('id_fuente','varchar');
        $this->captura('id_organismo','varchar');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('beneficiario','varchar');
        $this->captura('banco_benef','varchar');
        $this->captura('cuenta_benef','varchar');
        $this->captura('banco_origen','varchar');
        $this->captura('cta_origen','varchar');
        $this->captura('libreta_origen','varchar');
        $this->captura('usuario_apro','varchar');
        $this->captura('monto_benef','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }*/

    function insertarSigepAdqDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_sigep_adq_det_ime';
        $this->transaccion='SIGEP_SAD_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_sigep_adq','id_sigep_adq','int4');
        $this->setParametro('gestion','gestion','int4');
        $this->setParametro('clase_gasto_cip','clase_gasto_cip','int4');
        $this->setParametro('moneda','moneda','int4');
        $this->setParametro('total_autorizado_mo','total_autorizado_mo','numeric');
        $this->setParametro('id_ptogto','id_ptogto','int4');
        $this->setParametro('monto_partida','monto_partida','numeric');
        $this->setParametro('tipo_doc_rdo','tipo_doc_rdo','int4');
        $this->setParametro('nro_doc_rdo','nro_doc_rdo','int4');
        $this->setParametro('sec_doc_rdo','sec_doc_rdo','int4');
        $this->setParametro('fecha_elaboracion','fecha_elaboracion','date');
        $this->setParametro('justificacion','justificacion','varchar');
        $this->setParametro('id_fuente','id_fuente','varchar');
        $this->setParametro('id_organismo','id_organismo','varchar');
        $this->setParametro('beneficiario','beneficiario','varchar');
        $this->setParametro('banco_benef','banco_benef','varchar');
        $this->setParametro('cuenta_benef','cuenta_benef','varchar');
        $this->setParametro('banco_origen','banco_origen','varchar');
        $this->setParametro('cta_origen','cta_origen','varchar');
        $this->setParametro('libreta_origen','libreta_origen','varchar');
        $this->setParametro('usuario_apro','usuario_apro','varchar');
        $this->setParametro('monto_benef','monto_benef','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarSigepAdqDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_sigep_adq_det_ime';
        $this->transaccion='SIGEP_SAD_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_sigep_adq_det','id_sigep_adq_det','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_sigep_adq','id_sigep_adq','int4');
        $this->setParametro('gestion','gestion','int4');
        $this->setParametro('clase_gasto_cip','clase_gasto_cip','int4');
        $this->setParametro('moneda','moneda','int4');
        $this->setParametro('total_autorizado_mo','total_autorizado_mo','numeric');
        $this->setParametro('id_ptogto','id_ptogto','int4');
        $this->setParametro('monto_partida','monto_partida','numeric');
        $this->setParametro('tipo_doc_rdo','tipo_doc_rdo','int4');
        $this->setParametro('nro_doc_rdo','nro_doc_rdo','int4');
        $this->setParametro('sec_doc_rdo','sec_doc_rdo','int4');
        $this->setParametro('fecha_elaboracion','fecha_elaboracion','date');
        $this->setParametro('justificacion','justificacion','varchar');
        $this->setParametro('id_fuente','id_fuente','varchar');
        $this->setParametro('id_organismo','id_organismo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarSigepAdqDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_sigep_adq_det_ime';
        $this->transaccion='SIGEP_SAD_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_sigep_adq_det','id_sigep_adq_det','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function cargarSigepAdqDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_sigep_adq_det_ime';
        $this->transaccion='SIGEP_SAD_CHAR';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','varchar');
        $this->setParametro('momento','momento','varchar');
        $this->setParametro('sigep_adq','sigep_adq','varchar');
        //$this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
        //var_dump($this->respuesta);exit;
    }
    /*function cargarSigepContDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_sigep_adq_det_ime';
        $this->transaccion='SIGEP_SCONT_CHAR';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_int_comprobante','id_int_comprobante','int4');
        $this->setParametro('momento','momento','varchar');
        $this->setParametro('sigep_adq','sigep_adq','varchar');
        //$this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump($this->respuesta);
        return $this->respuesta;

    }*/
    function cargarSigepCip(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_sigep_adq_det_ime';
        $this->transaccion='SIGEP_CIP_CHAR';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('momento','momento','varchar');
        $this->setParametro('sigep_adq','sigep_adq','varchar');
        //$this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump($this->respuesta);
        return $this->respuesta;

    }
    function cargarSigepReguDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_sigep_adq_det_ime';
        $this->transaccion='SIGEP_REGU_CHAR';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('momento','momento','varchar');
        $this->setParametro('sigep_adq','sigep_adq','varchar');
        //$this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump($this->respuesta);
        return $this->respuesta;
    }
    function cargarSigepSip(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_sigep_adq_det_ime';
        $this->transaccion='SIGEP_SIP_CHAR';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_int_comprobante','id_int_comprobante','int4');
        $this->setParametro('momento','momento','varchar');
        $this->setParametro('sigep_adq','sigep_adq','varchar');
        //$this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump($this->respuesta);
        return $this->respuesta;

    }

}
?>