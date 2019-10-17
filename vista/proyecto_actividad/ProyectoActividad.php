<?php
/**
*@package pXP
*@file gen-ProyectoActividad.php
*@author  (franklin.espinoza)
*@date 06-09-2017 21:27:18
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoActividad=Ext.extend(Phx.gridInterfaz,{
	fheight: '75%',
	fwidth: '65%',
	bdel:true,
	bsave:false,
	btest:false,
	constructor:function(config){
		this.maestro=config.maestro;
		this.id_gestion = undefined;
    	//llama al constructor de la clase padre
		Phx.vista.ProyectoActividad.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag}})
	},

	iniciarEventos: function () {

		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
			params:{fecha:new Date()},
			success:function (resp) {
				var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
				if(!reg.ROOT.error){
					this.id_gestion = reg.ROOT.datos.id_gestion;
				}else{
					alert('Ocurrio un error al obtener la Gestión')
				}
			},
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});

	},

	onButtonNew: function () {

		Phx.vista.ProyectoActividad.superclass.onButtonNew.call(this);
		this.Cmp.id_categoria_programatica.store.baseParams = {par_filtro: 'cppr.codigo#cppr.descripcion', id_gestion:this.id_gestion};
	},
	onButtonEdit: function () {
		Phx.vista.ProyectoActividad.superclass.onButtonEdit.call(this);
		this.Cmp.id_categoria_programatica.store.baseParams = {par_filtro: 'cppr.codigo#cppr.descripcion', id_gestion:this.id_gestion};
	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proyecto_actividad'
			},
			type:'Field',
			form:true 
		},

		{
			config:{
				name: 'id_catprg',
				fieldLabel: 'Id. Categoria Prog.',
				allowBlank: false,
				anchor: '100%',
				gwidth: 110,
				maxLength:20
			},
			type:'NumberField',
			filters:{pfiltro:'pro_act.id_catprg',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'id_entidad',
				fieldLabel: 'Id. Entidad',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20
			},
			type:'NumberField',
			filters:{pfiltro:'pro_act.id_entidad',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'programa',
				fieldLabel: 'Programa',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			bottom_filter: true,
			filters:{pfiltro:'pro_act.programa',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'proyecto',
				fieldLabel: 'Proyecto',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:15
			},
			type:'NumberField',
			bottom_filter: true,
			filters:{pfiltro:'pro_act.proyecto',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'actividad',
				fieldLabel: 'Actividad',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			bottom_filter: true,
			filters:{pfiltro:'pro_act.actividad',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'desc_catprg',
				fieldLabel: 'Desc. Categoria Prog.',
				allowBlank: false,
				anchor: '100%',
				gwidth: 300,
				maxLength:1000,
				renderer: function (value, p, record) {
					return String.format('<b>{0}</b>', value);
				}
			},
				type:'TextField',
				bottom_filter: true,
				filters:{pfiltro:'pro_act.desc_catprg',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'nivel',
				fieldLabel: 'Nivel',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20
			},
			type:'TextField',
			bottom_filter: true,
			filters:{pfiltro:'pro_act.nivel',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'id_programa',
				fieldLabel: 'Id. Programa',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20
			},
			type:'NumberField',
			filters:{pfiltro:'pro_act.id_programa',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config: {
				name: 'id_categoria_programatica',
				fieldLabel: 'Categoria Programática',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CategoriaProgramatica/listarCategoriaProgramatica',
					id: 'id_categoria_programatica',
					root: 'datos',
					sortInfo: {
						field: 'descripcion',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_categoria_programatica', 'descripcion', 'codigo_programa', 'codigo_proyecto', 'codigo_actividad', 'codigo_fuente_fin', 'codigo_origen_fin'],
					remoteSort: true,
					baseParams: {par_filtro: 'cpr.descripcion'}
				}),
				valueField: 'id_categoria_programatica',
				displayField: 'descripcion',
				gdisplayField: 'desc_cat_prog',
				hiddenName: 'id_categoria_programatica',
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
				resizable: true,
				tpl: new Ext.XTemplate([
					'<tpl for=".">',
					'<div class="x-combo-list-item">',
					'<div class="awesomecombo-item {checked}">',
					'<p><b>Codigo: {codigo_programa}-{codigo_proyecto}-{codigo_actividad}-{codigo_fuente_fin}-{codigo_origen_fin}</b></p>',
					'</div><p><b>Descripción:</b> <span style="color: green;">{descripcion}</span></p>',
					'</div></tpl>'
				]),
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_cat_prog']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			bottom_filter:true,
			filters: {pfiltro: 'tcp.descripcion',type: 'string'},
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
				filters:{pfiltro:'pro_act.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},

		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'pro_act.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'pro_act.fecha_reg',type:'date'},
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
				filters:{pfiltro:'pro_act.usuario_ai',type:'string'},
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
				filters:{pfiltro:'pro_act.fecha_mod',type:'date'},
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
	title:'Proyecto y Actividad',
	ActSave:'../../sis_sigep/control/ProyectoActividad/insertarProyectoActividad',
	ActDel:'../../sis_sigep/control/ProyectoActividad/eliminarProyectoActividad',
	ActList:'../../sis_sigep/control/ProyectoActividad/listarProyectoActividad',
	id_store:'id_proyecto_actividad',
	fields: [
		{name:'id_proyecto_actividad', type: 'numeric'},
		{name:'id_programa', type: 'numeric'},
		{name:'desc_catprg', type: 'string'},
		{name:'id_catprg', type: 'numeric'},
		{name:'id_categoria_programatica', type: 'numeric'},
		{name:'programa', type: 'numeric'},
		{name:'id_entidad', type: 'numeric'},
		{name:'proyecto', type: 'string'},
		{name:'nivel', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'actividad', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_cat_prog', type: 'string'}

	],
	sortInfo:{
		field: 'id_proyecto_actividad',
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
				collapseFirst: false,

				width: '100%',
				//autoHeight: true,
				padding: '0 0 0 10',
				items:[
					{
						bodyStyle: 'padding-right:10px; padding-left:10px;',

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
						bodyStyle: 'padding-right:10px;',

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
		
		