<?php
/**
*@package pXP
*@file gen-OrganismoFinanciador.php
*@author  (franklin.espinoza)
*@date 30-08-2017 15:25:07
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.OrganismoFinanciador=Ext.extend(Phx.gridInterfaz,{
	btest: false,
	bsave: false,
	fwidth: '65%',

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.OrganismoFinanciador.superclass.constructor.call(this,config);
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

		Phx.vista.OrganismoFinanciador.superclass.onButtonNew.call(this);

		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
			params:{fecha:new Date()},
			success:function (resp) {
				var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
				if(!reg.ROOT.error){
					this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
					this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.anho);
					this.desc_gestion = this.Cmp.id_gestion.getRawValue();
					this.Cmp.id_cp_organismo_fin.store.baseParams = {par_filtro: 'cpof.codigo#cpof.descripcion', id_gestion:reg.ROOT.datos.id_gestion};
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
		var rec = this.getSelectedData();
		this.Cmp.id_cp_organismo_fin.store.baseParams = {par_filtro: 'cpof.codigo#cpof.descripcion', id_gestion:rec.id_gestion};
		Phx.vista.OrganismoFinanciador.superclass.onButtonEdit.call(this);
	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_organismo_financiador'
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
				name: 'id_organismo',
				fieldLabel: 'Id. Organismo',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
			type:'NumberField',
			filters:{pfiltro:'org_fin.id_organismo',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'organismo',
				fieldLabel: 'Organismo',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:4,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
			type:'NumberField',
			bottom_filter: true,
			filters:{pfiltro:'org_fin.organismo',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'desc_organismo',
				fieldLabel: 'Desc Organismo',
				allowBlank: false,
				anchor: '100%',
				gwidth: 300,
				maxLength:300,
				renderer: function (value) {
					return String.format('{0}', value);
				}
			},
			type:'TextField',
			bottom_filter: true,
			filters:{pfiltro:'org_fin.desc_organismo',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'sigla_organismo',
				fieldLabel: 'Sigla Organismo',
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
			filters:{pfiltro:'org_fin.sigla_organismo',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'id_cp_organismo_fin',
				fieldLabel: 'Organismo Financiador',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpOrganismoFin/listarCpOrganismoFin',
					id: 'id_cp_organismo_fin',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_organismo_fin', 'descripcion', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'cpof.codigo#cpof.descripcion'}
				}),
				valueField: 'id_cp_organismo_fin',
				displayField: 'descripcion',
				gdisplayField: 'desc_organismo_fin',
				hiddenName: 'id_cp_organismo_fin',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 200,
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
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_organismo_fin']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			bottom_filter: true,
			filters: {pfiltro: 'tof.descripcion',type: 'string'},
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
				filters:{pfiltro:'org_fin.estado_reg',type:'string'},
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
				filters:{pfiltro:'org_fin.fecha_reg',type:'date'},
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
				filters:{pfiltro:'org_fin.usuario_ai',type:'string'},
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
				filters:{pfiltro:'org_fin.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'org_fin.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'OrganismoFinanciador',
	ActSave:'../../sis_sigep/control/OrganismoFinanciador/insertarOrganismoFinanciador',
	ActDel:'../../sis_sigep/control/OrganismoFinanciador/eliminarOrganismoFinanciador',
	ActList:'../../sis_sigep/control/OrganismoFinanciador/listarOrganismoFinanciador',
	id_store:'id_organismo_financiador',
	fields: [
		{name:'id_organismo_financiador', type: 'numeric'},
		{name:'id_cp_organismo_fin', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'desc_organismo', type: 'string'},
		{name:'sigla_organismo', type: 'string'},
		{name:'organismo', type: 'numeric'},
		{name:'id_organismo', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_gestion', type: 'numeric'},
		{name:'gestion', type: 'numeric'},
		{name:'desc_organismo_fin', type: 'string'}

	],
	sortInfo:{
		field: 'id_organismo_financiador',
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
		
		