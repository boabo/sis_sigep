<?php
/**
*@package pXP
*@file gen-Acreedor.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:04:47
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Acreedor=Ext.extend(Phx.gridInterfaz,{
	btest: false,
	bsave: false,
	fwidth: '65%',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Acreedor.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_acreedor'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'acreedor',
				fieldLabel: 'Acreedor',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				bottom_filter: true,
				filters:{pfiltro:'acree.acreedor',type:'numeric'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'desc_acreedor',
				fieldLabel: 'Desc Acreedor',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:250
			},
			type:'TextField',
			bottom_filter: true,
			filters:{pfiltro:'acree.desc_acreedor',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'tipo_acreedor',
				fieldLabel: 'Tipo Acreedor',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:25
			},
			type:'TextField',
			bottom_filter: true,
			filters:{pfiltro:'acree.tipo_acreedor',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'de_ley',
				fieldLabel: 'De Ley',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:5
			},
			type:'TextField',
			filters:{pfiltro:'acree.de_ley',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		/*{
            config: {
                name: 'id_tipo_obligacion_columna',
                fieldLabel: 'Obligación Columna',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_sigep/control/Acreedor/listarObligacionColumna',
                    id: 'id_tipo_obligacion_columna',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_obligacion_columna','id_tipo_obligacion', 'nombre', 'codigo', 'codigo_pla', 'nombre_pla'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'tto.nombre#tto.codigo',pago:'si'}
                }),
                valueField: 'id_tipo_obligacion_columna',
                displayField: 'nombre',
                gdisplayField: 'desc_obligacion_col',
                hiddenName: 'id_tipo_obligacion_columna',
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
                    '<p><b>Cod. Planilla:</b> <span style="color: green;">{codigo_pla}</span></p>',
                    '<p><b>Nom. Planilla:</b> <span style="color: green;">{nombre_pla}</span></p>',
                    '</div></tpl>'
                ]),
                renderer : function(value, p, record) {
                    return String.format('<b style="color: green;">{0}</b>', record.data['desc_obligacion_col']);
                }
            },
            type: 'AwesomeCombo',
            id_grupo: 1,
            bottom_filter:true,
            filters: {pfiltro: 'tto.nombre#tto.codigo',type: 'string'},
            grid: true,
            form: true
        },*/

        {
            config: {
                name: 'id_tipo_columna',
                fieldLabel: 'Tipo Retencion',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_sigep/control/Acreedor/listarTipoColumna',
                    id: 'id_tipo_columna',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_columna', 'nombre', 'codigo', 'codigo_pla', 'nombre_pla'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'tto.nombre#tto.codigo',retencion:'si'}
                }),
                valueField: 'id_tipo_columna',
                displayField: 'nombre',
                gdisplayField: 'desc_obligacion_col',
                hiddenName: 'id_tipo_columna',
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
                    '<p><b>Cod. Planilla:</b> <span style="color: green;">{codigo_pla}</span></p>',
                    '<p><b>Nom. Planilla:</b> <span style="color: green;">{nombre_pla}</span></p>',
                    '</div></tpl>'
                ]),
                renderer : function(value, p, record) {
                    return String.format('<b style="color: green;">{0}</b>', record.data['desc_obligacion_col']);
                }
            },
            type: 'AwesomeCombo',
            id_grupo: 1,
            bottom_filter:true,
            filters: {pfiltro: 'tto.nombre#tto.codigo',type: 'string'},
            grid: true,
            form: true
        },

		{
			config: {
				name: 'id_afp',
				fieldLabel: 'AFP',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/Afp/listarAfp',
					id: 'id_afp',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_afp', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'afp.nombre#afp.codigo'}
				}),
				valueField: 'id_afp',
				displayField: 'nombre',
				gdisplayField: 'desc_afp',
				hiddenName: 'id_afp',
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
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_afp']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			bottom_filter:true,
			filters: {pfiltro: 'taf.codigo#taf.nombre',type: 'string'},
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
				filters:{pfiltro:'acree.estado_reg',type:'string'},
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
				filters:{pfiltro:'acree.id_usuario_ai',type:'numeric'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'acree.usuario_ai',type:'string'},
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
				filters:{pfiltro:'acree.fecha_reg',type:'date'},
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
				filters:{pfiltro:'acree.fecha_mod',type:'date'},
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
	title:'Acreedor',
	ActSave:'../../sis_sigep/control/Acreedor/insertarAcreedor',
	ActDel:'../../sis_sigep/control/Acreedor/eliminarAcreedor',
	ActList:'../../sis_sigep/control/Acreedor/listarAcreedor',
	id_store:'id_acreedor',
	fields: [
		{name:'id_acreedor', type: 'numeric'},
		{name:'acreedor', type: 'numeric'},
		{name:'id_afp', type: 'numeric'},
		{name:'de_ley', type: 'string'},
		{name:'desc_acreedor', type: 'string'},
		{name:'tipo_acreedor', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_tipo_columna', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_obligacion_col', type: 'string'},
		{name:'desc_afp', type: 'string'}

	],
	sortInfo:{
		field: 'id_acreedor',
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

