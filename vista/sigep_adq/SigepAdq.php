<?php
/**
 *@package pXP
 *@file gen-SigepAdq.php
 *@author  (rzabala)
 *@date 15-03-2019 21:10:26
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<style type="text/css" rel="stylesheet">
    .x-selectable,
    .x-selectable * {
        -moz-user-select: text !important;
        -khtml-user-select: text !important;
        -webkit-user-select: text !important;
    }

    .x-grid-row td,
    .x-grid-summary-row td,
    .x-grid-cell-text,
    .x-grid-hd-text,
    .x-grid-hd,
    .x-grid-row,

    .x-grid-row,
    .x-grid-cell,
    .x-unselectable
    {
        -moz-user-select: text !important;
        -khtml-user-select: text !important;
        -webkit-user-select: text !important;
    }
</style>
<script>
    Phx.vista.SigepAdq=Ext.extend(Phx.gridInterfaz,{

        viewConfig: {
            stripeRows: false,
            getRowClass: function(record) {
                return "x-selectable";
            }
        },
        constructor:function(config){
            /*this.panelResumen = new Ext.Panel({
                //html:'Hola Prueba',
                height: 100,
                renderTo: Ext.getBody(),
                items:[{
                    xtype:'textfield',
                    fieldLabel:'Name',
                    region: 'south'
                }]
            });*/
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.SigepAdq.superclass.constructor.call(this,config);


            this.addButton('btnreenviar', {
                //grupo: [0],
                text: 'Reenviar C31',
                iconCls: 'breload2',
                disabled: false,
                handler:this.onButtonReenviar,
                tooltip: '<b>Reenviar C31</b><br/>Reenvia solicitud al Sigep'
            });

            this.init();
            //var that = this;



            /*this.addButton('btnprocesar', {
                //grupo: [0],
                text: 'Procesar C31',
                iconCls: 'bball_green',
                disabled: false,
                handler:this.onButtonProcesar,
                tooltip: '<b>Procesar C31</b><br/>Procesa un documento C31 en Sigep'
            });*/

            /*this.addButton('btnbeneficiario', {
                //grupo: [0],
                text: 'Beneficiario',
                iconCls: 'bok',
                disabled: false,
                //handler:this.onButtonRevertir,
                tooltip: '<b>Beneficiario</b><br/>Adiciona al beneficiario desde el ERP con el Documento de Identidad o Nit'
            });*/

            /*if(that.sigep_adq == 'vbsigepadq'){
                this.store.baseParams.num_tramite = that.maestro.num_tramite;
                this.store.baseParams.sigep_adq = that.sigep_adq;
                console.log('datos en sigep: ',that.sigep_adq, that.maestro.num_tramite,  this.store.baseParams.num_tramite);
            }
            if(that.sigep_adq == 'vbsigepconta'){
                this.store.baseParams.num_tramite = that.nro_tramite;
                this.store.baseParams.sigep_adq = that.sigep_adq;
                console.log('datos en sigep: ',that.sigep_adq, that.nro_tramite,  this.store.baseParams.num_tramite);
            }
            if(that.sigep_adq == 'vbsigepcontaregu'){
                this.store.baseParams.num_tramite = that.nro_tramite;
                this.store.baseParams.sigep_adq = that.sigep_adq;
                console.log('datos en sigep: ',that.sigep_adq, that.nro_tramite,  this.store.baseParams.num_tramite);
            }*/

            this.load({params:{start:0, limit:this.tam_pag}})
        },

        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_sigep_adq'
                },
                type:'Field',
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
                filters:{pfiltro:'sadq.estado_reg',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'num_tramite',
                    fieldLabel: 'Tramite',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:17,
                    style: 'background-color: #9BF592; background-image: none;',
                    renderer: function(value, p, record){
                        return String.format('<b style="color:blue; ">{0}</b>', record.data['num_tramite']);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'sadq.num_tramite',type:'string'},
                id_grupo:1,
                grid:true,
                form:true,
                bottom_filter:true
            },
            {
                config:{
                    name: 'estado',
                    fieldLabel: 'Estado',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:50,
                    renderer: function (value, p, record) {
                        if (record.data['estado'] == 'registrado') {
                            return String.format('<div title="registrado"><b><font color="green">{0}</font></b></div>', value);

                        } else if (record.data['estado'] == 'procesando'){
                            return String.format('<div title="procesando"><b><font color="#9400d3">{0}</font></b></div>', value);
                        }else if (record.data['estado'] == 'finalizado'){
                            return String.format('<div title="finalizado"><b><font color="red">{0}</font></b></div>', value);
                        }else{
                            return String.format('<div title="pre-registro"><b><font color="666600">{0}</font></b></div>', value);
                        }
                    }
                },
                type:'TextField',
                filters:{pfiltro:'sadq.estado',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'momento',
                    fieldLabel: 'Momentos (Pre-Com-Dev)',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 140,
                    maxLength:20,
                    renderer: function (value, p, record) {
                        if (record.data['momento'] == 'CON_IMPUTACION') {
                            return String.format('<div title="CON_IMPUTACION"><b><font color="#b8860b">{0}</font></b></div>', value);
                        }else if(record.data['momento'] == 'REGULARIZACION'){
                            return String.format('<div title="REGULA"><b><font color="#CD7232">{0}</font></b></div>', value);
                        } else {
                            return String.format('<div title="SIN_IMPUTACION"><b><font color="gray">{0}</font></b></div>', value);
                        }
                    }
                },
                type:'TextField',
                filters:{pfiltro:'sadq.momento',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'id_service_request',
                    fieldLabel: 'Id Service Request',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:20,
                    renderer: function(value, p, record){
                        return String.format('<b style="color:mediumvioletred; ">{0}</b>', record.data['id_service_request']);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'sadq.id_service_request',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'nro_preventivo',
                    fieldLabel: 'Nro. Preventivo',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:20,
                    renderer: function(value, p, record){
                        var nro_comp = record.data['nro_preventivo'];
                        if(nro_comp == null){
                            return '';
                        }else {
                            return String.format('<div style="font-size:15px; color:teal; text-align:center; font-weight:bolder;"><b>{0}</b></div>', record.data['nro_preventivo']);
                        //return String.format('<b style="color:teal; ">{0}</b>', record.data['nro_preventivo']);
                    }}
                },
                type:'TextField',
                filters:{pfiltro:'sadq.nro_preventivo',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true,
                bottom_filter:true
            },
            {
                config:{
                    name: 'nro_comprometido',
                    fieldLabel: 'Nro. Comprometido',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:20,
                    renderer: function(value, p, record){
                        var nro_comp = record.data['nro_comprometido'];
                        if(nro_comp == null){
			                return '';
                        }else {
                            return String.format('<div style="font-size:15px; color:teal; text-align:center; font-weight:bolder;"><b>{0}</b></div>', record.data['nro_comprometido']);
                        //'<div style="color:red; text-align:center; font-weight:bold;"><b>{0}</b></div>'
                        //return String.format('<div style="color:teal; text-align:center; font-weight:bold;"><b>{}</b></div>', record.data['nro_comprometido']);
                    }}
                },
                type:'TextField',
                filters:{pfiltro:'sadq.nro_comprometido',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true,
                bottom_filter:true
            },
            {
                config:{
                    name: 'nro_devengado',
                    fieldLabel: 'Nro. Devengado',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:20,
                    renderer: function(value, p, record){
                        var nro_comp = record.data['nro_devengado'];
                        if(nro_comp == null){
                            return '';
                        }else {
                            return String.format('<div style="font-size:15px; color:teal; text-align:center; font-weight:bolder;"><b>{0}</b></div>', record.data['nro_devengado']);
                            //'<div style="color:red; text-align:center; font-weight:bold;"><b>{0}</b></div>'
                            //return String.format('<div style="color:teal; text-align:center; font-weight:bold;"><b>{}</b></div>', record.data['nro_comprometido']);
                        }}
                },
                type:'TextField',
                filters:{pfiltro:'sadq.nro_devengado',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true,
                bottom_filter:true
            },
            {
                config:{
                    name: 'ultimo_mensaje',
                    fieldLabel: 'Ultimo Mensaje',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 270,
                    maxLength:300,
                    renderer: function(value, p, record){
                        return String.format('<div title="Mensaje: {1}"><b><font color="black">{0}</font></b></div>', value, record.data.ultimo_mensaje);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'sadq.ultimo_mensaje',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'clase_gasto',
                    fieldLabel: 'Clase de Gasto',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 120,
                    maxLength:200
                },
                type:'TextField',
                filters:{pfiltro:'sadq.clase_gasto',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
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
                filters:{pfiltro:'sadq.fecha_reg',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'id_usuario_ai',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:4
                },
                type:'Field',
                filters:{pfiltro:'sadq.id_usuario_ai',type:'numeric'},
                id_grupo:1,
                grid:false,
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
                filters:{pfiltro:'sadq.usuario_ai',type:'string'},
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
                filters:{pfiltro:'sadq.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            }
        ],
        tam_pag:50,
        title:'Sigep Adquisiciones',
        ActSave:'../../sis_sigep/control/SigepAdq/insertarSigepAdq',
        ActDel:'../../sis_sigep/control/SigepAdq/eliminarSigepAdq',
        ActList:'../../sis_sigep/control/SigepAdq/listarSigepAdq',
        id_store:'id_sigep_adq',
        fields: [
            {name:'id_sigep_adq', type: 'numeric'},
            {name:'estado_reg', type: 'string'},
            {name:'num_tramite', type: 'string'},
            {name:'estado', type: 'string'},
            {name:'momento', type: 'string'},
            {name:'ultimo_mensaje', type: 'string'},
            {name:'clase_gasto', type: 'string'},
            {name:'id_service_request', type: 'string'},
            {name:'nro_preventivo', type: 'numeric'},
            {name:'nro_comprometido', type: 'numeric'},
            {name:'nro_devengado', type: 'numeric'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'usuario_ai', type: 'string'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},

        ],
        sortInfo:{
            field: 'id_sigep_adq',
            direction: 'DESC'
        },
        bdel:true,
        bsave:false,
        btest:false,
        bedit:false,
        bnew:false,

        onButtonReenviar: function() {
            Phx.CP.loadingShow();
            //var estadoHijo = Phx.CP.getPagina(this.id_sigep_adq_det).getSelectedData();
            var d = this.sm.getSelected().data;
            console.log('probando SIGEP:',d.id_sigep_adq);
            Ext.Ajax.request({
                url:'../../sis_sigep/control/SigepAdq/ReenviarC31',
                params:{id_sigep_adq:d.id_sigep_adq},
                success:this.successall,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
            this.reload();
            //window.location.reload();
            //history.go(0);
            console.log('EL DATO ES:',d);
        },
        onButtonProcesar: function() {
            Phx.CP.loadingShow();
            //var estadoHijo = Phx.CP.getPagina(this.id_sigep_adq_det).getSelectedData();
            var d = this.sm.getSelected().data;
            console.log('procesar SIGEP:',d);
            //var iter= 0;
            //while(iter <= 10) {
            Ext.Ajax.request({
                url: '../../sis_sigep/control/SigepAdq/ProcesarC31',
                params: {id_service_request: d.id_service_request},
                success: this.successall,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
            this.global_resp = d;
            this.actionStatus(this.global_resp);
            this.reload();
            //iter ++
            //}
            //this.successall(d.id_service_request);
            //window.location.reload();
            //history.go(0);
        },
        successall: function(d){
            //var rec={maestro:this.sm.getSelected().data};
            console.log('esto es DDD:', this.global_resp);
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(d.responseText));
            if(!reg.ROOT.error){
                //this.actionStatus(this.global_resp);
                this.reload();
            }
            //this.actionStatus(this.global_resp);
        },

        actionStatus: function(resp){
            console.log('actionStatus llego DDD:', resp);
            Ext.Ajax.request({
                url:'../../sis_sigep/control/SigepAdq/StatusC31',
                params:{id_service_request:resp.id_service_request},
                success:this.successall,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },
        tabsouth:[
            {
                url:'../../../sis_sigep/vista/sigep_adq_det/SigepAdqDet.php',
                title:'Datos C31 Sigep Detalle',
                //width:'40%',
                height: '50%',
                cls:'SigepAdqDet'
            }
        ]/*,
    east:{
        url:'../../../sis_sigep/vista/sigep_adq/nroPreventivo.php',
        title:'Datos C31 Sigep Recuperados',
        //width:'40%',
        height: '20%',
        cls:'ConsumoPreventivo'
    }*/

    });
</script>

