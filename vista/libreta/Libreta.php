<?php
/**
*@package pXP
*@file gen-Libreta.php
*@author  (franklin.espinoza)
*@date 08-09-2017 14:59:30
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Libreta=Ext.extend(Phx.gridInterfaz,{
	btest: false,
	bsave: false,
	fwidth: '65%',
	fheight: '65%',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Libreta.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_libreta_boa'
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
					return String.format('{0}', value);
				}

			},
			type:'NumberField',
			filters:{pfiltro:'libreta.banco',type:'numeric'},
			id_grupo:0,
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
					return String.format('{0}', value);
				}

			},
			type:'TextField',
			bottom_filter: true,
			filters:{pfiltro:'libreta.cuenta',type:'string'},
			id_grupo:0,
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
					return String.format('{0}', value);
				}
			},
			type:'NumberField',
			filters:{pfiltro:'libreta.id_libreta',type:'numeric'},
			id_grupo:0,
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
					return String.format('{0}', value);
				}
			},
			type:'TextField',
			bottom_filter: true,
			filters:{pfiltro:'libreta.libreta',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'desc_libreta',
				fieldLabel: 'Desc. Libreta',
				allowBlank: false,
				anchor: '100%',
				gwidth: 250,
				maxLength:250,
				renderer : function(value, p, record) {
					return String.format('<b>{0}</b>', value);
				}
			},
			type:'TextField',
			bottom_filter: true,
			filters:{pfiltro:'libreta.desc_libreta',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'moneda',
				fieldLabel: 'Moneda',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:25,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
				type:'NumberField',
				filters:{pfiltro:'libreta.moneda',type:'numeric'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'estado_libre',
				fieldLabel: 'Estado Libre',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:5,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
				type:'TextField',
				filters:{pfiltro:'libreta.estado_libre',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			config: {
				name: 'id_cuenta_bancaria',
				fieldLabel: 'Cuenta Bancaria',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancaria',
					id: 'id_cuenta_bancaria',
					root: 'datos',
					sortInfo: {
						field: 'nro_cuenta',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cuenta_bancaria', 'nro_cuenta', 'denominacion'],
					remoteSort: true,
					baseParams: {par_filtro: 'ctaban.nro_cuenta#ctaban.denominacion'}
				}),
				valueField: 'id_cuenta_bancaria',
				displayField: 'denominacion',
				gdisplayField: 'desc_cuenta_banco',
				hiddenName: 'id_cuenta_bancaria',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 250,
				minChars: 2,
				tpl: new Ext.XTemplate([
					'<tpl for=".">',
					'<div class="x-combo-list-item">',
					'<div class="awesomecombo-item {checked}">',
					'<p><b>Numero: {nro_cuenta}</b></p>',
					'</div><p><b>Nombre:</b> <span style="color: green;">{denominacion}</span></p>',
					'</div></tpl>'
				]),
				renderer : function(value, p, record) {
					return String.format('<b style="color: green">{0}</b>', record.data['desc_cuenta_banco']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			bottom_filter: true,
			filters: {pfiltro: 'tcb.nro_cuenta#tcb.denominacion',type: 'string'},
			grid: true,
			form: true
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
				filters:{pfiltro:'libreta.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'libreta.fecha_reg',type:'date'},
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
				filters:{pfiltro:'libreta.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'libreta.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'libreta.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
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
		}
	],
	tam_pag:50,	
	title:'Libreta',
	ActSave:'../../sis_sigep/control/Libreta/insertarLibreta',
	ActDel:'../../sis_sigep/control/Libreta/eliminarLibreta',
	ActList:'../../sis_sigep/control/Libreta/listarLibreta',
	id_store:'id_libreta_boa',
	fields: [
		{name:'id_libreta_boa', type: 'numeric'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'moneda', type: 'numeric'},
		{name:'banco', type: 'numeric'},
		{name:'estado_libre', type: 'string'},
		{name:'desc_libreta', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_libreta', type: 'numeric'},
		{name:'libreta', type: 'string'},
		{name:'cuenta', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_cuenta_banco', type: 'string'},

	],
	sortInfo:{
		field: 'id_libreta_boa',
		direction: 'ASC'
	},
	Grupos: [
		{
			layout: 'column',
			border: false,
			defaults: {
				border: false
			},

			items:[{
				xtype: 'fieldset',
				border: false,
				split: true,
				layout: 'column',
				region: 'north',
				autoScroll: true,
				autoHeight: true,
				collapseFirst: false,

				width: '100%',
				//autoHeight: true,
				padding: '0 0 0 10',
				items:[
					{
						bodyStyle: 'padding-right:5px;',

						border: false,
						autoHeight: true,
						items: [

							{
								xtype: 'fieldset',
								title: 'DATOS SIGEP',
								layout: 'form',
								width: 400,
								//autoHeight: true,
								items: [/*this.compositeFields()*/],
								padding: '0 0 0 10',
								bodyStyle: 'padding-left:20px;',
								id_grupo: 0
							}
						]
					}
					,
					{
						bodyStyle: 'padding-right:5px;',

						border: false,
						autoHeight: true,
						items: [
							{
								xtype: 'fieldset',
								layout: 'form',
								width: 400,
								title: 'DATOS BOA',
								//autoHeight: true,
								items: [],
								padding: '0 0 0 10',
								bodyStyle: 'padding-left:5px;',
								id_grupo: 1
							}
						]
					}
				]
			}]
		}
	]
});
</script>
		
		