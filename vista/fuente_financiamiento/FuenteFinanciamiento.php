<?php
/**
*@package pXP
*@file gen-FuenteFinanciamiento.php
*@author  (franklin.espinoza)
*@date 30-08-2017 15:54:19
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FuenteFinanciamiento=Ext.extend(Phx.gridInterfaz,{
	fheight: '60%',
	fwidth: '65%',
	bdel:true,
	bsave:false,
	btest:false,
	constructor:function(config){
		this.maestro=config.maestro;
		this.desc_gestion = '';
    	//llama al constructor de la clase padre
		Phx.vista.FuenteFinanciamiento.superclass.constructor.call(this,config);
        this.addButton('clonarFuenteFinanciamiento',
            {
                //grupo: [0],
                text: 'Clonar Fuente Financiamiento',
                iconCls: 'bexport',
                disabled: false,
                handler: this.clonarFuenteFinanciamiento,
                tooltip: '<b>Clonar</b><br/>Clonar Fuente Financiamiento.'
            }
        );
		this.init();
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag}})
	},

    clonarFuenteFinanciamiento: function () {

        Ext.Msg.show({
            title: 'Fuente Financiamiento',
            msg: '<b style="color: red;">Esta seguro de Clonar los registros de Fuente Financiamiento.</b>',
            fn: function (btn){
                if(btn == 'ok'){
                    var record = this.getSelectedData();
                    Phx.CP.loadingShow();

                    Ext.Ajax.request({
                        url: '../../sis_sigep/control/FuenteFinanciamiento/clonarFuenteFinanciamiento',
                        params: {
                            id_fuente_financiamiento : 0
                        },
                        success: function (resp) {
                            Phx.CP.loadingHide();
                            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                            if (reg.ROOT.error) {
                                Ext.Msg.alert('Error', 'Al Clonar Fuente Financiamiento: ' + reg.ROOT.error)
                            } else {
                                this.reload();
                            }
                        },
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });

                }
            },
            buttons: Ext.Msg.OKCANCEL,
            width: 450,
            maxWidth:500,
            icon: Ext.Msg.WARNING,
            scope:this
        });

    },

	iniciarEventos: function () {

		this.Cmp.id_gestion.on('blur', function (rec) {

			this.Cmp.id_gestion.setRawValue(this.desc_gestion);
		},this);

	},

	onButtonNew: function () {

		Phx.vista.FuenteFinanciamiento.superclass.onButtonNew.call(this);

		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
			params:{fecha:new Date()},
			success:function (resp) {
				var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
				if(!reg.ROOT.error){
					this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
					this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.anho);
					this.desc_gestion = this.Cmp.id_gestion.getRawValue();
					this.Cmp.id_cp_fuente_fin.store.baseParams = {par_filtro: 'cpff.codigo#cpff.descripcion', id_gestion:reg.ROOT.datos.id_gestion};
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
		this.Cmp.id_cp_fuente_fin.store.baseParams = {par_filtro: 'cpff.codigo#cpff.descripcion', id_gestion:rec.id_gestion};
		Phx.vista.FuenteFinanciamiento.superclass.onButtonEdit.call(this);
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fuente_financiamiento'
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
				name: 'id_fuente',
				fieldLabel: 'Id Fuente Fin.',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
			type:'NumberField',
			filters:{pfiltro:'fue_fin.id_fuente',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'fuente',
				fieldLabel: 'Fuente',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:4,
				renderer : function(value, p, record) {
					return String.format('{0}', value);
				}
			},
			type:'NumberField',
			bottom_filter : true,
			filters:{pfiltro:'fue_fin.fuente',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'desc_fuente',
				fieldLabel: 'Desc. Fuente',
				allowBlank: false,
				anchor: '100%',
				gwidth: 300,
				maxLength:250,
				renderer: function (value) {
					return String.format('{0}', value);
				}
			},
			type:'TextField',
			bottom_filter : true,
			filters:{pfiltro:'fue_fin.desc_fuente',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'sigla_fuente',
				fieldLabel: 'Sigla Fuente',
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
			filters:{pfiltro:'fue_fin.sigla_fuente',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config: {
				name: 'id_cp_fuente_fin',
				fieldLabel: 'Fuente Financiamiento',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpFuenteFin/listarCpFuenteFin',
					id: 'id_cp_fuente_fin',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_fuente_fin', 'codigo', 'descripcion'],
					remoteSort: true,
					baseParams: {par_filtro: 'cpff.codigo#cpff.descripcion'}
				}),
				valueField: 'id_cp_fuente_fin',
				displayField: 'descripcion',
				gdisplayField: 'desc_fuente_fin',
				hiddenName: 'id_cp_fuente_fin',
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
					'<p><b>Descripción: {descripcion}</b></p>',
					'</div><p><b>Codigo:</b> <span style="color: green;">{codigo}</span></p>',
					'</div></tpl>'
				]),
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_fuente_fin']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			bottom_filter: true,
			filters: {pfiltro: 'tff.descripcion',type: 'string'},
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
				filters:{pfiltro:'fue_fin.estado_reg',type:'string'},
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
				filters:{pfiltro:'fue_fin.usuario_ai',type:'string'},
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
				filters:{pfiltro:'fue_fin.fecha_reg',type:'date'},
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
				filters:{pfiltro:'fue_fin.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'fue_fin.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'FuenteFinanciamiento',
	ActSave:'../../sis_sigep/control/FuenteFinanciamiento/insertarFuenteFinanciamiento',
	ActDel:'../../sis_sigep/control/FuenteFinanciamiento/eliminarFuenteFinanciamiento',
	ActList:'../../sis_sigep/control/FuenteFinanciamiento/listarFuenteFinanciamiento',
	id_store:'id_fuente_financiamiento',
	fields: [
		{name:'id_fuente_financiamiento', type: 'numeric'},
		{name:'id_cp_fuente_fin', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'fuente', type: 'numeric'},
		{name:'sigla_fuente', type: 'string'},
		{name:'desc_fuente', type: 'string'},
		{name:'id_fuente', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'gestion', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'desc_fuente_fin', type: 'string'}

	],
	sortInfo:{
		field: 'id_fuente_financiamiento',
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
		
		