<?php
/**
*@package pXP
*@file gen-MODCuentaBancaria.php
*@author  (franklin.espinoza)
*@date 08-09-2017 13:42:27
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaBancaria extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='sigep.ft_cuenta_bancaria_sel';
		$this->transaccion='SIGEP_CUEN_BAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('id_cuenta_bancaria_boa','int4');
		$this->captura('banco','int4');
		$this->captura('cuenta','varchar');
		$this->captura('desc_cuenta','varchar');
		$this->captura('moneda','int4');
		$this->captura('tipo_cuenta','bpchar');
		$this->captura('estado_cuenta','bpchar');

		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cuenta_banco','varchar');

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_bancaria_ime';
		$this->transaccion='SIGEP_CUEN_BAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion


		$this->setParametro('banco','banco','int4');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('desc_cuenta','desc_cuenta','varchar');
		$this->setParametro('moneda','moneda','int4');
		$this->setParametro('tipo_cuenta','tipo_cuenta','bpchar');
		$this->setParametro('estado_cuenta','estado_cuenta','bpchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');



		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_bancaria_ime';
		$this->transaccion='SIGEP_CUEN_BAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_cuenta_bancaria_boa','id_cuenta_bancaria_boa','int4');
		$this->setParametro('desc_cuenta','desc_cuenta','varchar');
		$this->setParametro('moneda','moneda','int4');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('tipo_cuenta','tipo_cuenta','bpchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado_cuenta','estado_cuenta','bpchar');
		$this->setParametro('banco','banco','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='sigep.ft_cuenta_bancaria_ime';
		$this->transaccion='SIGEP_CUEN_BAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria_boa','id_cuenta_bancaria_boa','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}


    function synchronizeCuentaBancaria(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='sigep.ft_cuenta_bancaria_ime';
        $this->transaccion='SIGEP_CUEN_BAN_SYNC';
        $this->tipo_procedimiento='IME';

        /************************************************ token ************************************************/
        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => "https://sigep.sigma.gob.bo/rsseguridad/apiseg/token?grant_type=refresh_token&client_id=0&redirect_uri=%2Fmodulo%2Fapiseg%2Fredirect&client_secret=0&refresh_token=FEA520426600:Wk5yBGCh5TeT8jUG5lPkwIT25Jmlwav5XqtxhCrmgr5Yc0iaAMPZgLILZZPC7mjxk5tUgVusBs0RXlSDkIuWq2qNat2KsUM3E4q7",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_HTTPHEADER => array(
                "cache-control: no-cache",
                "content-type: application/x-www-form-urlencoded"
            ),
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);

        curl_close($curl);

        $token_response = json_decode($response);
        $access_token = $token_response->{'access_token'};
        /************************************************ token ************************************************/

        /************************************************ perfil ************************************************/
        //$jsonConverter = new StandardConverter();
        $param_p = array("gestion" => "2022", "perfil" => "915");
        //$param_p = $jsonConverter->encode($param_p);
        $param_p = json_encode($param_p);
        $curl_p = curl_init();

        $curl_array_p = array(
            CURLOPT_URL => 'https://sigep.sigma.gob.bo/rsbeneficiarios/api/cambiaperfil',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'PUT',
            CURLOPT_HTTPHEADER => array(
                "Authorization: bearer " . $access_token,
                "Cache-Control: no-cache",
                "Content-Type: application/json"
            ),
            CURLOPT_POSTFIELDS => $param_p
        );

        curl_setopt_array($curl_p,$curl_array_p);
        $response_p = curl_exec($curl_p);
        $err_p = curl_error($curl_p);
        $http_code_p = curl_getinfo( $curl_p, CURLINFO_HTTP_CODE );
        curl_close($curl_p);
        /************************************************ perfil ************************************************/

        /************************************************ cuentas ************************************************/
        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => "https://sigep.sigma.gob.bo/rsclasificadores/api/v1/cuentasbancarias/cuentabancaria?idEntidad=494&fechaConsulta=04-07-2022",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => array(
                "Authorization: bearer " . $access_token,
                "Cache-Control: no-cache",
                "Postman-Token: 011d15eb-f4ff-48db-85a6-1b380958342b"
            ),
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);

        curl_close($curl);

        //var_dump('$response',/*curl_getinfo($curl),*/ json_decode($response)->data);exit;
        /************************************************ cuentas ************************************************/
        //$this->objParam->addParametro('jsonData', json_decode($response)->data);
        $this->arreglo['jsonData'] = json_encode(json_decode($response)->data);
        //Define los parametros para la funcion
        $this->setParametro('jsonData','jsonData','jsonb');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo ($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>