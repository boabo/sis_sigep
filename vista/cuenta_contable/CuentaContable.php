<?php
/**
*@package pXP
*@file gen-CuentaContable.php
*@author  (franklin.espinoza)
*@date 07-09-2017 16:53:56
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaContable=Ext.extend(Phx.gridInterfaz,{
	btest: false,
	bsave: false,
	fwidth: '65%',
	constructor:function(config){
		this.maestro=config.maestro;
		this.desc_gestion = '';

        this.tbarItems = ['-',
            this.cmbGestion,'-'
        ];
    	//llama al constructor de la clase padre
		Phx.vista.CuentaContable.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();

        Ext.Ajax.request({
            url:'../../sis_reclamo/control/Reclamo/getDatosOficina',
            params:{id_usuario:0},
            success:function(resp){
                var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));

                this.cmbGestion.setValue(reg.ROOT.datos.id_gestion);
                this.cmbGestion.setRawValue(reg.ROOT.datos.gestion);

                this.store.baseParams.id_gestion = reg.ROOT.datos.id_gestion;
                this.load({params:{start:0, limit:this.tam_pag}});

            },
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });

        this.addButton('btnClonCueCon',{
            grupo:[0],
            text: 'Clonar Cuenta Contable',
            iconCls: 'bchecklist',
            disabled: false,
            handler: this.onClonarCuentaContable,
            tooltip: '<b>Clonar Cuenta Contable </b><br/>Clonar Cuenta Contable para la siguiente gestión'
        });

        this.cmbGestion.on('select',this.capturarEventos, this);

		this.load({params:{start:0, limit:this.tam_pag}})
	},

    capturarEventos: function () {
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.load({params:{start:0, limit:this.tam_pag}});
    },

    onClonarCuentaContable : function(){

        Ext.Msg.show({
            title: 'Cuenta Contable',
            msg: '<b style="color: red;">Esta seguro de Clonar Cuenta Contable de la Gestión '+this.cmbGestion.getRawValue()+' a la Gestión '+(+this.cmbGestion.getRawValue()+1)+'.</b>',
            fn: function (btn){
                if(btn == 'ok'){

                    Phx.CP.loadingShow();
                    let record = this.getSelectedData();

                    Ext.Ajax.request({
                        url:'../../sis_sigep/control/CuentaContable/clonarCuentaContable',
                        params:{
                            id_gestion : this.cmbGestion.getValue(),
                            gestion    : this.cmbGestion.getRawValue()
                        },
                        success: function (resp) {
                            var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                            var datos = reg.ROOT.datos;
                            Phx.CP.loadingHide();
                            console.log('datos fuera',datos);
                            if(!reg.ROOT.error){
                                console.log('datos',datos);
                                Ext.Msg.show({
                                    title: 'Estado SIGEP',
                                    msg: '<b>Estimado Funcionario: '+'\n'+'Los registros de Cuenta Contable se Clonaron satisfactoriamente en el ERP.</b>',
                                    buttons: Ext.Msg.OK,
                                    width: 512,
                                    icon: Ext.Msg.INFO
                                });
                            }else{
                                Ext.Msg.show({
                                    title: 'Estado SIGEP',
                                    msg: '<b>Estimado Funcionario: '+'\n'+'Hubo algunos inconvenientes al Clonar los registros de Cuenta Contable.</b>',
                                    buttons: Ext.Msg.OK,
                                    width: 512,
                                    icon: Ext.Msg.INFO
                                });
                            }
                        },
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope:this
                    });
                }
            },
            buttons: Ext.Msg.OKCANCEL,
            width: 350,
            maxWidth:500,
            icon: Ext.Msg.WARNING,
            scope:this
        });
    },

    cmbGestion: new Ext.form.ComboBox({
        name: 'gestion',
        id: 'gestion_cc',
        fieldLabel: 'Gestion',
        allowBlank: true,
        emptyText:'Gestion...',
        blankText: 'Año',
        editable: false,
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_parametros/control/Gestion/listarGestion',
                id: 'id_gestion',
                root: 'datos',
                sortInfo:{
                    field: 'gestion',
                    direction: 'DESC'
                },
                totalProperty: 'total',
                fields: ['id_gestion','gestion'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'gestion'}
            }),
        valueField: 'id_gestion',
        triggerAction: 'all',
        displayField: 'gestion',
        hiddenName: 'id_gestion',
        mode:'remote',
        pageSize:50,
        queryDelay:500,
        listWidth:'280',
        hidden:false,
        width:80
    }),

	iniciarEventos: function () {

		this.Cmp.id_gestion.on('blur', function (rec) {

			this.Cmp.id_gestion.setRawValue(this.desc_gestion);
		},this);

        /*this.Cmp.id_gestion.on('select', function (cmb, record, index) { console.log('gestion',  record.id, index);
            this.Cmp.id_cuenta.store.baseParams = {par_filtro: 'cta.nombre_cuenta#cta.nro_cuenta', tipo_cuenta:'gasto', id_gestion: record.id};
        }, this);*/

	},

	onButtonNew: function () {

		Phx.vista.CuentaContable.superclass.onButtonNew.call(this);

		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
			params:{fecha:new Date()},
			success:function (resp) {
				var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
				if(!reg.ROOT.error){
					this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
					this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.anho);
					this.desc_gestion = this.Cmp.id_gestion.getRawValue();
					this.Cmp.id_cuenta.store.baseParams = {par_filtro: 'cta.nombre_cuenta#cta.nro_cuenta', /*tipo_cuenta:'gasto',*/ id_gestion: reg.ROOT.datos.id_gestion};
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
		Phx.vista.CuentaContable.superclass.onButtonEdit.call(this);
		var rec = this.getSelectedData();
		//this.Cmp.id_cuenta.store.baseParams = {par_filtro: 'cta.nombre_cuenta#cta.nro_cuenta', tipo_cuenta:'pasivo', id_gestion: rec.id_gestion};//anterior filtro
        this.Cmp.id_cuenta.store.baseParams = {par_filtro: 'cta.nombre_cuenta#cta.nro_cuenta', id_gestion: rec.id_gestion};
	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_contable'
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
				editable: true,
				disabled: false,
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
            filters:{pfiltro:'cue_cont.id_gestion',type:'numeric'},
			id_grupo : 1,
			form : true,
			grid:true
		},
		{
			config:{
				name: 'modelo_contable',
				fieldLabel: 'modelo Contable',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'cue_cont.modelo_contable',type:'numeric'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'cuenta_contable',
				fieldLabel: 'Cuenta Contable',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
			type:'TextField',
			bottom_filter: true,
			filters:{pfiltro:'cue_cont.cuenta_contable',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'des_cuenta_contable',
				fieldLabel: 'Desc. Cuenta Contable',
				allowBlank: false,
				anchor: '80%',
				gwidth: 250,
				maxLength:250,
				renderer : function(value, p, record) {
					return String.format('<b>{0}</b>', value);
				}
			},
				type:'TextField',
				bottom_filter: true,
				filters:{pfiltro:'cue_cont.des_cuenta_contable',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'imputable',
				fieldLabel: 'Imputable',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'cue_cont.imputable',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
		{
			config: {
				name: 'id_cuenta',
				fieldLabel: 'Cuenta',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/Cuenta/listarCuenta',
					id: 'id_cuenta',
					root: 'datos',
					sortInfo: {
						field: 'nro_cuenta',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cuenta', 'nombre_cuenta', 'nro_cuenta', 'desc_moneda'],
					remoteSort: true,
					baseParams: {par_filtro: 'cta.nombre_cuenta#cta.nro_cuenta'/*, tipo_cuenta:'gasto'*/}
				}),
				valueField: 'id_cuenta',
				displayField: 'nombre_cuenta',
				gdisplayField: 'desc_cuenta',
				hiddenName: 'id_cuenta',
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
                resizable: true,
				tpl: new Ext.XTemplate([
					'<tpl for=".">',
					'<div class="x-combo-list-item">',
					'<div class="awesomecombo-item {checked}">',
					'<p><b>Nro. Cuenta: {nro_cuenta}</b></p>',
					'</div><p><b>Nombre:</b> <span style="color: green;">{nombre_cuenta}</span></p>',
					'</div></tpl>'
				]),
				renderer : function(value, p, record) {
					return String.format('<b style="color: green;">{0}</b>', record.data['desc_cuenta']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			bottom_filter: true,
			filters: {pfiltro: 'tc.nro_cuenta#tc.nombre_cuenta',type: 'string'},
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
				filters:{pfiltro:'cue_cont.estado_reg',type:'string'},
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
				filters:{pfiltro:'cue_cont.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'cue_cont.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cue_cont.usuario_ai',type:'string'},
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
				filters:{pfiltro:'cue_cont.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'CuentaContable',
	ActSave:'../../sis_sigep/control/CuentaContable/insertarCuentaContable',
	ActDel:'../../sis_sigep/control/CuentaContable/eliminarCuentaContable',
	ActList:'../../sis_sigep/control/CuentaContable/listarCuentaContable',
	id_store:'id_cuenta_contable',
	fields: [
		{name:'id_cuenta_contable', type: 'numeric'},
		{name:'des_cuenta_contable', type: 'string'},
		{name:'cuenta_contable', type: 'string'},
		{name:'imputable', type: 'string'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_gestion', type: 'numeric'},
		{name:'modelo_contable', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_cuenta', type: 'string'},
		{name:'gestion', type: 'numeric'},

	],
	sortInfo:{
		field: 'id_cuenta_contable',
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
		
		