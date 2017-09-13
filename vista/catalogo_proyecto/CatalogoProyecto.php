<?php
/**
*@package pXP
*@file gen-CatalogoProyecto.php
*@author  (franklin.espinoza)
*@date 06-09-2017 21:31:34
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CatalogoProyecto=Ext.extend(Phx.gridInterfaz,{
	fheight: '60%',
	fwidth: '65%',
	bdel:true,
	bsave:false,
	btest:false,
	constructor:function(config){
		this.maestro=config.maestro;
		this.desc_gestion = '';
    	//llama al constructor de la clase padre
		Phx.vista.CatalogoProyecto.superclass.constructor.call(this,config);
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

		Phx.vista.CatalogoProyecto.superclass.onButtonNew.call(this);

		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
			params:{fecha:new Date()},
			success:function (resp) {
				var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
				if(!reg.ROOT.error){
					this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
					this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.anho);
					this.desc_gestion = this.Cmp.id_gestion.getRawValue();
					this.Cmp.id_cp_proyecto.store.baseParams = {par_filtro: 'cppr.codigo#cppr.descripcion', id_gestion:reg.ROOT.datos.id_gestion};

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
		Phx.vista.CatalogoProyecto.superclass.onButtonEdit.call(this);
		var rec = this.getSelectedData();
		this.Cmp.id_cp_proyecto.store.baseParams = {par_filtro: 'cppr.codigo#cppr.descripcion', id_gestion:rec.id_gestion};
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_catalogo_proyecto'
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
				name: 'id_catpry',
				fieldLabel: 'Id. Categoria Proy.',
				allowBlank: false,
				anchor: '100%',
				gwidth: 110,
				maxLength:20
			},
			type:'NumberField',
			filters:{pfiltro:'cat_pro.id_catpry',type:'numeric'},
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
			filters:{pfiltro:'cat_pro.id_entidad',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'sisin',
				fieldLabel: 'SISIN',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:50
			},
			type:'TextField',
			bottom_filter:true,
			filters:{pfiltro:'cat_pro.sisin',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'desc_catpry',
				fieldLabel: 'Desc. Categoria Proy.',
				allowBlank: false,
				anchor: '100%',
				gwidth: 300,
				maxLength:1000
			},
			type:'TextField',
			buttom_filter: true,
			filters:{pfiltro:'cat_pro.desc_catpry',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
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
			filters:{pfiltro:'cat_pro.id_catprg',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config: {
				name: 'id_cp_proyecto',
				fieldLabel: 'Proyecto',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				resizable:true,
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpProyecto/listarCpProyecto',
					id: 'id_cp_proyecto',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_proyecto', 'descripcion', 'codigo', 'codigo_sisin'],
					remoteSort: true,
					baseParams: {par_filtro: 'cppr.descripcion#cppr.codigo'}
				}),
				valueField: 'id_cp_proyecto',
				displayField: 'descripcion',
				gdisplayField: 'desc_proyecto',
				hiddenName: 'id_cp_proyecto',
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
					'</div><p><b>Descripción:</b> <span style="color: green;">{descripcion}</span></p>',
					'</div></tpl>'
				]),
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_proyecto']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			bottom_filter:true,
			filters: {pfiltro: 'tp.descripcion#tp.codigo',type: 'string'},
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
				filters:{pfiltro:'cat_pro.estado_reg',type:'string'},
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
				filters:{pfiltro:'cat_pro.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'cat_pro.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cat_pro.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cat_pro.fecha_mod',type:'date'},
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
	title:'CatalogoProyecto',
	ActSave:'../../sis_sigep/control/CatalogoProyecto/insertarCatalogoProyecto',
	ActDel:'../../sis_sigep/control/CatalogoProyecto/eliminarCatalogoProyecto',
	ActList:'../../sis_sigep/control/CatalogoProyecto/listarCatalogoProyecto',
	id_store:'id_catalogo_proyecto',
	fields: [
		{name:'id_catalogo_proyecto', type: 'numeric'},
		{name:'id_cp_proyecto', type: 'numeric'},
		{name:'id_catpry', type: 'numeric'},
		{name:'sisin', type: 'string'},
		{name:'desc_catpry', type: 'string'},
		{name:'id_entidad', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_catprg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'gestion', type: 'string'},
		{name:'desc_proyecto', type: 'string'}

	],
	sortInfo:{
		field: 'id_catalogo_proyecto',
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
		
		