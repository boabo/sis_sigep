<?php
/**
*@package pXP
*@file gen-UnidadEjecutora.php
*@author  (franklin.espinoza)
*@date 06-09-2017 20:53:10
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UnidadEjecutora=Ext.extend(Phx.gridInterfaz,{

	fheight: '60%',
	fwidth: '65%',
	bdel:true,
	bsave:false,
	btest:false,
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.UnidadEjecutora.superclass.constructor.call(this,config);
        this.addButton('clonarUnidadEjecutora',
            {
                //grupo: [0],
                text: 'Clonar Unidad Ejecutora',
                iconCls: 'bexport',
                disabled: false,
                handler: this.clonarUnidadEjecutora,
                tooltip: '<b>Clonar</b><br/>Clonar Unidad Ejecutora.'
            }
        );
		this.init();
		this.desc_gestion = '';
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag}})
	},

    clonarUnidadEjecutora: function () {

        Ext.Msg.show({
            title: 'Unidad Ejecutora',
            msg: '<b style="color: red;">Esta seguro de Clonar los registros de Unidad Ejecutora.</b>',
            fn: function (btn){
                if(btn == 'ok'){
                    var record = this.getSelectedData();
                    Phx.CP.loadingShow();

                    Ext.Ajax.request({
                        url: '../../sis_sigep/control/UnidadEjecutora/clonarUnidadEjecutora',
                        params: {
                            id_unidad_ejecutora : 0
                        },
                        success: function (resp) {
                            Phx.CP.loadingHide();
                            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                            if (reg.ROOT.error) {
                                Ext.Msg.alert('Error', 'Al Clonar Unidad Ejecutora: ' + reg.ROOT.error)
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
            console.log('rec', rec);
			this.Cmp.id_gestion.setRawValue(this.desc_gestion);
		},this);

	},

	onButtonNew: function () {

		Phx.vista.UnidadEjecutora.superclass.onButtonNew.call(this);

		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
			params:{fecha:new Date()},
			success:function (resp) {
				var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
				if(!reg.ROOT.error){
					this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
					this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.anho);
					this.desc_gestion = this.Cmp.id_gestion.getRawValue();

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
        //this.Cmp.id_ue.store.baseParams = {id_gestion:rec.id_gestion};
        this.Cmp.id_unidad_ejecutora.store.setBaseParam('id_gestion', rec.id_gestion);
        Phx.vista.UnidadEjecutora.superclass.onButtonEdit.call(this);
    },
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_unidad_ejecutora_boa'
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
				name: 'id_ue',
				fieldLabel: 'Id. Unidad Ejecutora',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20
			},
			type:'NumberField',
			filters:{pfiltro:'uni_eje.id_ue',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'id_da',
				fieldLabel: 'Id. Dirección Administrativa',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20
			},
			type:'NumberField',
			filters:{pfiltro:'uni_eje.id_da',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'ue',
				fieldLabel: 'Unidad Ejecutora',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				bottom_filter: true,
				filters:{pfiltro:'uni_eje.ue',type:'numeric'},
				id_grupo:0,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'desc_ue',
				fieldLabel: 'Desc. Unidad Ejecutora',
				allowBlank: false,
				anchor: '100%',
				gwidth: 250,
				maxLength:150
			},
				type:'TextField',
				bottom_filter: true,
				filters:{pfiltro:'uni_eje.desc_ue',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			config: {
				name: 'id_unidad_ejecutora',
				fieldLabel: 'Unidad Ejecutora',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/UnidadEjecutora/listarUnidadEjecutora',
					id: 'id_unidad_ejecutora',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_unidad_ejecutora', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'und_eje.nombre#und_eje.codigo'}
				}),
				valueField: 'id_unidad_ejecutora',
				displayField: 'nombre',
				gdisplayField: 'desc_unidad_ejec',
				hiddenName: 'id_unidad_ejecutora',
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
					'</div><p><b>Nombre:</b> <span style="color: green;">{nombre}</span></p>',
					'</div></tpl>'
				]),
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_unidad_ejec']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			bottom_filter: true,
			filters: {pfiltro: 'tue.nombre',type: 'string'},
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
				filters:{pfiltro:'uni_eje.estado_reg',type:'string'},
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
				filters:{pfiltro:'uni_eje.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'uni_eje.fecha_reg',type:'date'},
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
				filters:{pfiltro:'uni_eje.usuario_ai',type:'string'},
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
				filters:{pfiltro:'uni_eje.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Unidad Ejecutora',
	ActSave:'../../sis_sigep/control/UnidadEjecutora/insertarUnidadEjecutora',
	ActDel:'../../sis_sigep/control/UnidadEjecutora/eliminarUnidadEjecutora',
	ActList:'../../sis_sigep/control/UnidadEjecutora/listarUnidadEjecutora',
	id_store:'id_unidad_ejecutora_boa',
	fields: [
		{name:'id_unidad_ejecutora_boa', type: 'numeric'},
		{name:'ue', type: 'numeric'},
		{name:'desc_ue', type: 'string'},
		{name:'id_da', type: 'numeric'},
		{name:'id_unidad_ejecutora', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_gestion', type: 'numeric'},
		{name:'id_ue', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'gestion', type: 'numeric'},
		{name:'desc_unidad_ejec', type: 'string'}

	],
	sortInfo:{
		field: 'id_unidad_ejecutora_boa',
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
		
		