<?php
/**
*@package pXP
*@file gen-ClaseGastoCip.php
*@author  (franklin.espinoza)
*@date 07-09-2017 15:28:46
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ClaseGastoCip=Ext.extend(Phx.gridInterfaz,{

	btest: false,
	bsave: false,
	fwidth: '65%',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ClaseGastoCip.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_clase_gasto_cip'
			},
			type:'Field',
			form:true 
		},

		{
			config:{
				name: 'clase_gasto',
				fieldLabel: 'Clase Gasto',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			bottom_filter: true,
			filters:{pfiltro:'gas_cip.clase_gasto',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'desc_clase_gasto',
				fieldLabel: 'Desc. Clase Gasto',
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
				filters:{pfiltro:'gas_cip.desc_clase_gasto',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
		{
			config: {
				name: 'id_clase_gasto',
				fieldLabel: 'Clase Gasto',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/ClaseGasto/listarClaseGasto',
					id: 'id_clase_gasto',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_clase_gasto', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'clg.nombre#clg.codigo'}
				}),
				valueField: 'id_clase_gasto',
				displayField: 'nombre',
				gdisplayField: 'desc_clase_gas',
				hiddenName: 'id_clase_gasto',
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
					'<p><b>Codigo: {codigo}</b></p>',
					'</div><p><b>Nombre:</b> <span style="color: green;">{nombre}</span></p>',
					'</div></tpl>'
				]),
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_clase_gas']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			bottom_filter:true,
			filters: {pfiltro: 'tcg.nombre#tcg.codigo',type: 'string'},
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
			filters:{pfiltro:'gas_cip.estado_reg',type:'string'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'gas_cip.usuario_ai',type:'string'},
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
				filters:{pfiltro:'gas_cip.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'gas_cip.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'gas_cip.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Clase de Gasto CIP',
	ActSave:'../../sis_sigep/control/ClaseGastoCip/insertarClaseGastoCip',
	ActDel:'../../sis_sigep/control/ClaseGastoCip/eliminarClaseGastoCip',
	ActList:'../../sis_sigep/control/ClaseGastoCip/listarClaseGastoCip',
	id_store:'id_clase_gasto_cip',
	fields: [
		{name:'id_clase_gasto_cip', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'desc_clase_gasto', type: 'string'},
		{name:'id_clase_gasto', type: 'numeric'},
		{name:'clase_gasto', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_clase_gas', type: 'string'},

	],
	sortInfo:{
		field: 'id_clase_gasto_cip',
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
		
		