<?php
/**
*@package pXP
*@file gen-MatrizControl.php
*@author  (franklin.espinoza)
*@date 08-09-2017 18:56:26
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.MatrizControl=Ext.extend(Phx.gridInterfaz,{
	btest: false,
	bsave: false,
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.MatrizControl.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_matriz_control'
			},
			type:'Field',
			form:true 
		},

		{
			config:{
				name: 'banco',
				fieldLabel: 'Banco',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:25,
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', value);
				}
			},
			type:'TextField',
			filters:{pfiltro:'mat_cont.banco',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'cuenta',
				fieldLabel: 'Cuenta',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:25,
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', value);
				}
			},
			type:'TextField',
			filters:{pfiltro:'mat_cont.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'id_libreta',
				fieldLabel: 'Id Libreta',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:25,
				renderer : function(value, p, record) {
					return String.format('<b style="color: orangered;">{0}</b>', value);
				}
			},
			type:'TextField',
			filters:{pfiltro:'mat_cont.id_libreta',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'libreta',
				fieldLabel: 'Libreta',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:25,
				renderer : function(value, p, record) {
					return String.format('<b style="color: orangered;">{0}</b>', value);
				}
			},
				type:'TextField',
				filters:{pfiltro:'mat_cont.libreta',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'mat_cont.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},

		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'mat_cont.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'mat_cont.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'mat_cont.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'mat_cont.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'MatrizContro',
	ActSave:'../../sis_sigep/control/MatrizControl/insertarMatrizControl',
	ActDel:'../../sis_sigep/control/MatrizControl/eliminarMatrizControl',
	ActList:'../../sis_sigep/control/MatrizControl/listarMatrizControl',
	id_store:'id_matriz_control',
	fields: [
		{name:'id_matriz_control', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_libreta', type: 'numeric'},
		{name:'libreta', type: 'string'},
		{name:'cuenta', type: 'string'},
		{name:'banco', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_matriz_control',
		direction: 'ASC'
	}
});
</script>
		
		