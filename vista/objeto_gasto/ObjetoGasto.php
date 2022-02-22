<?php
/**
*@package pXP
*@file gen-ObjetoGasto.php
*@author  (franklin.espinoza)
*@date 30-08-2017 13:18:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObjetoGasto=Ext.extend(Phx.gridInterfaz,{

	btest: false,
	bsave: false,
	fwidth: '65%',
	constructor:function(config){
		this.maestro=config.maestro;
		this.desc_gestion = '';

        this.tbarItems = ['-',
            this.cmbGestion,'-'
        ];
		this.nuevo = false;

        Ext.Ajax.request({
            url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
            params:{fecha:new Date()},
            success:function (resp) {
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                if(!reg.ROOT.error){
                    this.cmbGestion.setValue(reg.ROOT.datos.id_gestion);
                    this.cmbGestion.setRawValue(reg.ROOT.datos.anho);
                    this.store.baseParams.id_gestion = reg.ROOT.datos.id_gestion;
                    this.load({params:{start:0, limit:this.tam_pag}});
                }else{
                    alert('Ocurrio un error al obtener la Gestión')
                }
            },
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });

    	//llama al constructor de la clase padre
		Phx.vista.ObjetoGasto.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();

        this.addButton('btnClonObjGas',{
            grupo:[0],
            text: 'Clonar Objeto Gasto',
            iconCls: 'bchecklist',
            disabled: false,
            handler: this.onClonarObjetoGasto,
            tooltip: '<b>Clonar Objeto Gasto </b><br/>Clonar Objeto Gasto para la siguiente gestión'
        });

        this.cmbGestion.on('select',this.capturarEventos, this);
		this.load({params:{start:0, limit:this.tam_pag}});
	},

    capturarEventos: function () {
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.load({params:{start:0, limit:this.tam_pag}});
    },

    onClonarObjetoGasto : function(){

        Ext.Msg.show({
            title: 'Objeto de Gasto',
            msg: '<b style="color: red;">Esta seguro de Clonar Objeto de Gasto de la Gestión '+this.cmbGestion.getRawValue()+' a la Gestión '+(+this.cmbGestion.getRawValue()+1)+'.</b>',
            fn: function (btn){
                if(btn == 'ok'){

                    Phx.CP.loadingShow();
                    let record = this.getSelectedData();

                    Ext.Ajax.request({
                        url:'../../sis_sigep/control/ObjetoGasto/clonarObjetoGasto',
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
                                    msg: '<b>Estimado Funcionario: '+'\n'+'Los registros de Objeto de Gasto se Clonaron satisfactoriamente en el ERP.</b>',
                                    buttons: Ext.Msg.OK,
                                    width: 512,
                                    icon: Ext.Msg.INFO
                                });
                            }else{
                                Ext.Msg.show({
                                    title: 'Estado SIGEP',
                                    msg: '<b>Estimado Funcionario: '+'\n'+'Hubo algunos inconvenientes al Clonar los registros de Objeto de Gasto</b>',
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
        id: 'gestion_og',
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


		this.Cmp.id_gestion.on('select', function (cmb, rec, index ) { console.log('rec', rec);
			this.desc_gestion = this.Cmp.id_gestion.getRawValue();
			//if(this.nuevo) {
				this.Cmp.id_partida.reset();
				this.Cmp.id_partida.modificado = true;
				this.Cmp.id_partida.store.baseParams = {
					par_filtro: 'par.codigo#par.nombre_partida',
					id_gestion: rec.id,
					sw_transaccional: 'movimiento'
				};
			//}
		},this);

		this.Cmp.id_gestion.on('blur', function (rec) {

			this.Cmp.id_gestion.setRawValue(this.desc_gestion);
		},this);

	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_objeto_gasto'
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
				//editable: false,

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
            filters:{pfiltro:'obj_gas.id_gestion',type:'numeric'},
			id_grupo : 1,
			form : true,
			grid:true
		},

		{
			config:{
				name: 'id_objeto',
				fieldLabel: 'Id. Objeto Sigep',
				allowBlank: false,
				anchor: '100%',
				gwidth: 150,
				maxLength:20
			},
			type:'NumberField',
			filters:{pfiltro:'obj_gas.id_objeto',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'objeto',
				fieldLabel: 'Objeto',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:20
			},
			type:'TextField',
			bottom_filter : true,
			filters:{pfiltro:'obj_gas.objeto',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name: 'desc_objeto',
				fieldLabel: 'Descripción Objeto',
				allowBlank: false,
				anchor: '100%',
				gwidth: 250,
				maxLength:1000
			},
			type:'TextField',
			bottom_filter : true,
			filters:{pfiltro:'obj_gas.desc_objeto',type:'string'},
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
			bottom_filter : true,
			filters:{pfiltro:'obj_gas.nivel',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},

		{
			config:{
				name:'id_partida',
				fieldLabel:'Partida',
				allowBlank:false,
				emptyText:'Partida...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/Partida/listarPartida',
					id: 'id_partida',
					root: 'datos',
					sortInfo:{
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_partida','codigo','nombre_partida','tipo','sw_movimiento'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro:'par.codigo#par.nombre_partida#par.id_gestion',sw_transaccional:'movimiento'}
				}),
				valueField: 'id_partida',
				displayField: 'nombre_partida',
				hiddenName: 'id_partida',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				resizable: true,
				anchor:'100%',
				minChars:2,
				gwidth: 300,
				renderer: function(value, p, record){
						return String.format('<div style="color: green;"><b>({0}) {1}</b><div>', record.data['codigo'],   record.data['nombre_partida']);
				},
				tpl: new Ext.XTemplate([
					'<tpl for=".">',
					'<div class="x-combo-list-item">',
					'<div class="awesomecombo-item {checked}">',
					'<p><b>{nombre_partida} ({codigo})</b></p>',
					'</div>',
					'<p><b>Tipo:</b> <span style="color: green;">{sw_movimiento}</span><b> Rubro: </b><span style="color: green;">{tipo}</span></p>',
					'</div>',
					'</tpl>'

				])
			},
			type:'ComboBox',
			bottom_filter: true,
			id_grupo:1,
			filters:{
				pfiltro: 'tp.codigo#tp.nombre_partida',
				type: 'string'
			},

			grid:true,
			form:true
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
				filters:{pfiltro:'obj_gas.estado_reg',type:'string'},
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
				filters:{pfiltro:'obj_gas.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'obj_gas.fecha_reg',type:'date'},
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
				filters:{pfiltro:'obj_gas.usuario_ai',type:'string'},
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
				filters:{pfiltro:'obj_gas.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'ObjetoGasto',
	ActSave:'../../sis_sigep/control/ObjetoGasto/insertarObjetoGasto',
	ActDel:'../../sis_sigep/control/ObjetoGasto/eliminarObjetoGasto',
	ActList:'../../sis_sigep/control/ObjetoGasto/listarObjetoGasto',
	id_store:'id_objeto_gasto',
	fields: [
		{name:'id_objeto_gasto', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'desc_objeto', type: 'string'},
		{name:'nivel', type: 'string'},
		{name:'objeto', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_objeto', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'nombre_partida', type: 'string'},
		{name:'gestion', type: 'numeric'}

	],
	sortInfo:{
		field: 'id_objeto_gasto',
		direction: 'ASC'
	},

	fheight: '60%',

	onButtonNew: function () {
		this.Cmp.id_gestion.setDisabled(false);
		Phx.vista.ObjetoGasto.superclass.onButtonNew.call(this);
		this.nuevo = true;
		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
			params:{fecha:new Date()},
			success:function (resp) {
				var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
				if(!reg.ROOT.error){
					this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
					this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.anho);
					this.desc_gestion = this.Cmp.id_gestion.getRawValue();
					
					this.Cmp.id_partida.store.baseParams ={par_filtro:'par.codigo#par.nombre_partida',id_gestion:this.Cmp.id_gestion.getValue(), sw_transaccional:'movimiento'};
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
		Phx.vista.ObjetoGasto.superclass.onButtonEdit.call(this);
		//this.Cmp.id_gestion.setDisabled(true);
		this.nuevo = false;
        var rec = this.getSelectedData();
        //this.Cmp.id_partida.store.setBaseParam(id_gestion, rec.id_gestion);

        this.Cmp.id_partida.store.baseParams ={id_gestion: rec.id_gestion};
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
		
		