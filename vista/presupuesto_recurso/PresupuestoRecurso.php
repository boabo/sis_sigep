<?php
/**
 *@package pXP
 *@file gen-PresupuestoRecurso.php
 *@author  (franklin.espinoza)
 *@date 06-09-2017 21:27:23
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PresupuestoRecurso=Ext.extend(Phx.gridInterfaz,{

        fwidth:'90%',
        fheight:'60%',
        bdel:true,
        bsave:false,
        btest:false,
        constructor:function(config){
            this.maestro=config.maestro;
            this.desc_gestion = '';
            //llama al constructor de la clase padre
            Phx.vista.PresupuestoRecurso.superclass.constructor.call(this,config);
            this.init();
            this.load({params:{start:0, limit:this.tam_pag}})
        },

        iniciarEventos: function () {

            this.Cmp.id_gestion.on('blur', function (rec) {

                this.Cmp.id_gestion.setRawValue(this.desc_gestion);
            },this);

        },

        onButtonNew: function () {

            Phx.vista.PresupuestoRecurso.superclass.onButtonNew.call(this);

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

        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_presupuesto_recurso'
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
                id_grupo : 2,
                form : true,
                grid:false
            },

            {
                config:{
                    name: 'gestion',
                    fieldLabel: 'gestion',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:4
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.gestion',type:'numeric'},
                id_grupo:0,
                grid:true,
                form:true
            },

            /*{
                config:{
                    name: 'id_ptogto',
                    fieldLabel: 'Id. Presupuesto Gasto',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                bottom_filter:true,
                filters:{pfiltro:'pre_gas.id_ptogto',type:'numeric'},
                id_grupo:0,
                grid:true,
                form:true
            },*/

            {
                config:{
                    name: 'id_entidad',
                    fieldLabel: 'Id. Entidad',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_entidad',type:'numeric'},
                id_grupo:0,
                grid:true,
                form:true
            },

            /*{
                config:{
                    name: 'id_da',
                    fieldLabel: 'Id Dirección Adm.',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_da',type:'numeric'},
                id_grupo:0,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'id_ue',
                    fieldLabel: 'Id. Unidad Ejecutora',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_ue',type:'numeric'},
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
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_catprg',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'id_catpry',
                    fieldLabel: 'Id Categoria Proy.',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_catpry',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
            },*/

            {
                config:{
                    name: 'id_fuente',
                    fieldLabel: 'Id Fuente',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_fuente',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'id_organismo',
                    fieldLabel: 'Id Organismo',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_organismo',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'id_rubro',
                    fieldLabel: 'Id Rubro',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_rubro',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'id_ent_otorgante',
                    fieldLabel: 'Id Ent Otorgante',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_ent_otorgante',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
            },

            /*{
                config:{
                    name: 'id_objeto',
                    fieldLabel: 'Id Objeto',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                bottom_filter:true,
                filters:{pfiltro:'pre_gas.id_objeto',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'id_ent_transferencia',
                    fieldLabel: 'Id Ent. Transferencia',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650
                },
                type:'NumberField',
                filters:{pfiltro:'pre_gas.id_ent_transferencia',type:'numeric'},
                id_grupo:2,
                grid:true,
                form:true
            },*/

            {
                config:{
                    name: 'ppto_inicial',
                    fieldLabel: 'Presupuesto Inicial',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650,
                    renderer : function(value, p, record) {
                        return String.format('<b style="color: orange;">{0}</b>', value);
                    }
                },
                type:'NumberField',
                bottom_filter: true,
                filters:{pfiltro:'pre_gas.ppto_inicial',type:'numeric'},
                id_grupo:2,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'ppto_vigente',
                    fieldLabel: 'Presupuesto Vigente',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650,
                    renderer : function(value, p, record) {
                        return String.format('<b style="color: orange;">{0}</b>', value);
                    }
                },
                type:'NumberField',
                bottom_filter: true,
                filters:{pfiltro:'pre_gas.ppto_vigente',type:'numeric'},
                id_grupo:2,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'devengado',
                    fieldLabel: 'Devengado',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650,
                    renderer : function(value, p, record) {
                        return String.format('<b style="color: orange;">{0}</b>', value);
                    }
                },
                type:'NumberField',
                bottom_filter: true,
                filters:{pfiltro:'pre_gas.devengado',type:'numeric'},
                id_grupo:2,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'percibido',
                    fieldLabel: 'Percibido',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:1179650,
                    renderer : function(value, p, record) {
                        return String.format('<b style="color: orange;">{0}</b>', value);
                    }
                },
                type:'NumberField',
                bottom_filter: true,
                filters:{pfiltro:'pre_gas.percibido',type:'numeric'},
                id_grupo:2,
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
                filters:{pfiltro:'pre_gas.estado_reg',type:'string'},
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
                filters:{pfiltro:'pre_gas.usuario_ai',type:'string'},
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
                filters:{pfiltro:'pre_gas.fecha_reg',type:'date'},
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
                filters:{pfiltro:'pre_gas.id_usuario_ai',type:'numeric'},
                id_grupo:1,
                grid:false,
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
                filters:{pfiltro:'pre_gas.fecha_mod',type:'date'},
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
        title:'PresupuestoRecurso',
        ActSave:'../../sis_sigep/control/PresupuestoGasto/insertarPresupuestoGasto',
        ActDel:'../../sis_sigep/control/PresupuestoGasto/eliminarPresupuestoGasto',
        ActList:'../../sis_sigep/control/PresupuestoRecurso/listarPresupuestoRecurso',
        id_store:'id_presupuesto_recurso',
        fields: [
            {name:'id_presupuesto_recurso', type: 'numeric'},
            {name:'id_ue', type: 'numeric'},
            {name:'gestion', type: 'numeric'},
            {name:'id_catpry', type: 'numeric'},
            {name:'id_gestion', type: 'numeric'},
            {name:'id_organismo', type: 'numeric'},
            {name:'ppto_inicial', type: 'numeric'},
            {name:'estado_reg', type: 'string'},
            {name:'credito_disponible', type: 'numeric'},
            {name:'id_catprg', type: 'numeric'},
            {name:'id_fuente', type: 'numeric'},
            {name:'id_ent_transferencia', type: 'numeric'},
            {name:'id_ptogto', type: 'numeric'},
            {name:'id_da', type: 'numeric'},
            {name:'id_objeto', type: 'numeric'},
            {name:'id_entidad', type: 'numeric'},
            {name:'ppto_vigente', type: 'numeric'},
            {name:'usuario_ai', type: 'string'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},

            {name:'id_rubro', type: 'numeric'},
            {name:'id_ent_otorgante', type: 'numeric'},
            {name:'devengado', type: 'numeric'},
            {name:'percibido', type: 'numeric'}
        ],
        sortInfo:{
            field: 'id_presupuesto_recurso',
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
                                    width: 380,
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
                                    width: 380,
                                    title: 'CATEGORIA PROGRAMÁTICA',
                                    //autoHeight: true,
                                    items: [],
                                    padding: '0 0 0 10',
                                    bodyStyle: 'padding-left:5px;',
                                    id_grupo: 1
                                }
                            ]
                        },
                        {
                            bodyStyle: 'padding-right:5px;',

                            border: false,
                            autoHeight: true,
                            items: [
                                {
                                    xtype: 'fieldset',
                                    layout: 'form',
                                    width: 380,
                                    title: 'PRESUPUESTO',
                                    //autoHeight: true,
                                    items: [],
                                    padding: '0 0 0 10',
                                    bodyStyle: 'padding-left:5px;',
                                    id_grupo: 2
                                }
                            ]
                        }
                    ]
                }]
            }
        ]
    });
</script>