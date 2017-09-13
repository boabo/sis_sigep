<?php
/**
*@package pXP
*@file gen-Programa.php
*@author  (franklin.espinoza)
*@date 06-09-2017 20:53:14
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Programa=Ext.extend(Phx.gridInterfaz,{

	fheight: '60%',
	fwidth: '65%',
	bdel:true,
	bsave:false,
	btest:false,
	constructor:function(config){
		this.maestro=config.maestro;
		this.desc_gestion = '';
    	//llama al constructor de la clase padre
		Phx.vista.Programa.superclass.constructor.call(this,config);

		this.init();
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag}})
	},

	iniciarEventos: function () {

		this.Cmp.id_gestion.on('blur', function (rec) {

			this.Cmp.id_gestion.setRawValue(this.desc_gestion);
		},this);

	},

	onButtonNew: function () {

		Phx.vista.Programa.superclass.onButtonNew.call(this);

		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
			params:{fecha:new Date()},
			success:function (resp) {
				var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
				if(!reg.ROOT.error){
					this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
					this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.anho);
					this.desc_gestion = this.Cmp.id_gestion.getRawValue();
					this.Cmp.id_cp_programa.store.baseParams = {par_filtro: 'cppr.codigo#cppr.descripcion', id_gestion:reg.ROOT.datos.id_gestion};

				}else{
					alert('Ocurrio un error al obtener la Gestión')
				}
			},
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});


	},
	onButtonEdit: function () {
		Phx.vista.Programa.superclass.onButtonEdit.call(this);
		var rec = this.getSelectedData();
		this.Cmp.id_cp_programa.store.baseParams = {par_filtro: 'cppr.codigo#cppr.descripcion', id_gestion:rec.id_gestion};
	},
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_programa_boa'
			},
			type:'Field',
			form:true 
		},

		{
			config:{
				name : 'id_gestion',
				origen : 'GESTION',
				fieldLabel : 'Gestión',
				allowBlank : false,
				editable: false,
				disabled: true,
				width: 125,
				listWidth:'232',
				pageSize: 5,
				forceSelection: true,
				typeAhead: true,
				renderer:function (value,p,record){

					return String.format('<div ext:qtip="Gestión"><b><font color="green">{0}</font></b><br></div>', record.data['gestion']);
				}
			},
			type : 'ComboRec',
			id_grupo : 1,
			form : true,
			grid:true
		},

		{
			config:{
				name: 'id_catprg',
				fieldLabel: 'Id. Categoria Prog.',
				allowBlank: false,
				anchor: '100%',
				gwidth: 120,
				maxLength:20
			},
			type:'NumberField',
			filters:{pfiltro:'pro.id_catprg',type:'numeric'},
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
			filters:{pfiltro:'pro.id_entidad',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},


		{
			config:{
				name: 'programa',
				fieldLabel: 'programa',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				bottom_filter:true,
				filters:{pfiltro:'pro.programa',type:'numeric'},
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
				maxLength:200,
				renderer: function (value, p, record) {
					return String.format('<b>{0}</b>', value);
				}
			},
				type:'TextField',
				bottom_filter: true,
				filters:{pfiltro:'pro.desc_catprg',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'nivel',
				fieldLabel: 'nivel',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				bottom_filter: true,
				filters:{pfiltro:'pro.nivel',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			config: {
				name: 'id_cp_programa',
				fieldLabel: 'Programa',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpPrograma/listarCpPrograma',
					id: 'id_cp_programa',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_programa', 'descripcion', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'cppr.descripcion#cppr.codigo'}
				}),
				valueField: 'id_cp_programa',
				displayField: 'descripcion',
				gdisplayField: 'desc_programa',
				hiddenName: 'id_cp_programa',
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
					'<p><b>Codigo: {codigo}</b></p>',
					'</div><p><b>Descripción:</b> <span style="color: green;">{descripcion}</span></p>',
					'</div></tpl>'
				]),
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_programa']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			filters: {pfiltro: 'tp.descripcion',type: 'string'},
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
				filters:{pfiltro:'pro.estado_reg',type:'string'},
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
				filters:{pfiltro:'pro.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'pro.fecha_reg',type:'date'},
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
				filters:{pfiltro:'pro.usuario_ai',type:'string'},
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
				filters:{pfiltro:'pro.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Programa',
	ActSave:'../../sis_sigep/control/Programa/insertarPrograma',
	ActDel:'../../sis_sigep/control/Programa/eliminarPrograma',
	ActList:'../../sis_sigep/control/Programa/listarPrograma',
	id_store:'id_programa_boa',
	fields: [
		{name:'id_programa_boa', type: 'numeric'},
		{name:'id_cp_programa', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'programa', type: 'numeric'},
		{name:'desc_catprg', type: 'string'},
		{name:'id_entidad', type: 'numeric'},
		{name:'nivel', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_catprg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'gestion', type: 'numeric'},
		{name:'desc_programa', type: 'string'},

	],
	sortInfo:{
		field: 'id_programa_boa',
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
		
		