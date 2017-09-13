<?php
/**
*@package pXP
*@file gen-Entidad.php
*@author  (franklin.espinoza)
*@date 30-08-2017 15:54:21
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Entidad=Ext.extend(Phx.gridInterfaz,{

	btest: false,
	bsave: false,
	fwidth: '65%',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Entidad.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_entidad_boa'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_entidad',
				fieldLabel: 'Id. Entidad',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
			type:'NumberField',
			filters:{pfiltro:'ent.id_entidad',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'entidad',
				fieldLabel: 'Entidad',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:10,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
			type:'NumberField',
			bottom_filter : true,
			filters:{pfiltro:'ent.entidad',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'desc_entidad',
				fieldLabel: 'Descripción Entidad',
				allowBlank: false,
				anchor: '100%',
				gwidth: 300,
				maxLength:250,
				renderer: function(value) {
					return String.format('{0}', value);
				}
			},
			type:'TextField',
			bottom_filter : true,
			filters:{pfiltro:'ent.desc_entidad',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'sigla_entidad',
				fieldLabel: 'Sigla Entidad',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:25,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
			type:'TextField',
			bottom_filter : true,
			filters:{pfiltro:'ent.sigla_entidad',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'tuicion_entidad',
				fieldLabel: 'Tuición Entidad',
				allowBlank: true,
				anchor: '100%',
				gwidth: 100,
				maxLength:10,
				renderer : function(value, p, record) {
					return String.format('{0}', value?value:'');
				}
			},
				type:'NumberField',
				filters:{pfiltro:'ent.tuicion_entidad',type:'numeric'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			 config: {
				 name: 'id_institucion',
				 fieldLabel: 'Intitución',
				 allowBlank: false,
				 emptyText: 'Elija una opción...',
				 store: new Ext.data.JsonStore({
				 url: '../../sis_parametros/control/Institucion/listarInstitucion',
				 id: 'id_institucion',
				 root: 'datos',
				 sortInfo: {
				 field: 'nombre',
				 direction: 'ASC'
				 },
				 totalProperty: 'total',
				 fields: ['id_institucion', 'nombre', 'celular1', 'email1'],
				 remoteSort: true,
				 baseParams: {par_filtro: 'instit.nombre#instit.celular1#instit.email1'}
				 }),
				 valueField: 'id_institucion',
				 displayField: 'nombre',
				 gdisplayField: 'desc_institucion',
				 hiddenName: 'id_institucion',
				 forceSelection: true,
				 typeAhead: false,
				 triggerAction: 'all',
				 lazyRender: true,
				 mode: 'remote',
				 pageSize: 15,
				 queryDelay: 1000,
				 anchor: '100%',
				 gwidth: 150,
				 minChars: 2,
				 tpl: new Ext.XTemplate([
					 '<tpl for=".">',
					 '<div class="x-combo-list-item">',
					 '<div class="awesomecombo-item {checked}">',
					 '<p><b>Nombre: {nombre}</b></p>',
					 '</div><p><b>Información:</b> <span style="color: green;">{celular1} - {email1}</span></p>',
					 '</div></tpl>'
				 ]),
				 renderer : function(value, p, record) {
				 	return String.format('<b style="color: green">{0}</b>', record.data['desc_institucion']);
				 }
			 },
			 type: 'AwesomeCombo',
			 id_grupo: 1,
			 bottom_filter: true,
			 filters: {pfiltro: 'tin.nombre',type: 'string'},
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
				filters:{pfiltro:'ent.estado_reg',type:'string'},
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
				filters:{pfiltro:'ent.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ent.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ent.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'ent.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Entidad',
	ActSave:'../../sis_sigep/control/Entidad/insertarEntidad',
	ActDel:'../../sis_sigep/control/Entidad/eliminarEntidad',
	ActList:'../../sis_sigep/control/Entidad/listarEntidad',
	id_store:'id_entidad_boa',
	fields: [
		{name:'id_entidad_boa', type: 'numeric'},
		{name:'id_institucion', type: 'numeric'},
		{name:'tuicion_entidad', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'sigla_entidad', type: 'string'},
		{name:'entidad', type: 'numeric'},
		{name:'desc_entidad', type: 'string'},
		{name:'id_entidad', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_institucion', type: 'string'}

	],
	sortInfo:{
		field: 'id_entidad_boa',
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
								title: 'CATEGORIA PROGRAMÁTICA',
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
		
		