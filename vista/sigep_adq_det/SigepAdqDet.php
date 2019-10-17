<?php
/**
 *@package pXP
 *@file gen-SigepAdqDet.php
 *@author  (rzabala)
 *@date 25-03-2019 15:50:47
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.SigepAdqDet=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.SigepAdqDet.superclass.constructor.call(this,config);
                this.init();
                /*this.addButton('btnreenviar', {
                    //grupo: [0],
                    text: 'Reenviar C31',
                    iconCls: 'breload2',
                    disabled: false,
                    handler:this.onButtonReenviar,
                    tooltip: '<b>Reenviar C31</b><br/>Reenvia solicitud al Sigep'
                });*/
                //this.load({params:{start:0, limit:this.tam_pag}})
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_sigep_adq_det'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name: 'id_sigep_adq',
                        fieldLabel: 'idSigepAdq',
                        allowBlank: true,
                        disabled: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.id_sigep_adq',type:'numeric'},
                    id_grupo:1,
                    grid:false,
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
                    filters:{pfiltro:'sad.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'gestion',
                        fieldLabel: 'Gestion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:black; ">{0}</b>', record.data['gestion']);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.gestion',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'clase_gasto_cip',
                        fieldLabel: 'clase Gasto',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:black; ">{0}</b>', record.data['clase_gasto_cip']);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.clase_gasto_cip',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'moneda',
                        fieldLabel: 'Moneda',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:blue; ">{0}</b>', record.data['moneda']);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.moneda',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'total_autorizado_mo',
                        fieldLabel: 'Monto Total Autorizado',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:red; ">{0}</b>', Ext.util.Format.number(record.data['total_autorizado_mo'],'0,000.00'));
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.total_autorizado_mo',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'sisin',
                        fieldLabel: 'SISIN',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:gray; ">{0}</b>', record.data['sisin']);
                        }

                    },
                    type:'TextField',
                    filters:{pfiltro:'sad.sisin',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'otfin',
                        fieldLabel: 'OTFIN',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:gray; ">{0}</b>', record.data['otfin']);
                        }

                    },
                    type:'TextField',
                    filters:{pfiltro:'sad.otfin',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'id_ptogto',
                        fieldLabel: 'Id Presupuesto Gasto',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:7,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:darkslategray; ">{0}</b>', record.data['id_ptogto']);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.id_ptogto',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'cuenta_contable',
                        fieldLabel: 'Cuenta Contable',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:7,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:darkslategray; ">{0}</b>', record.data['cuenta_contable']);
                        }
                    },
                    type:'TextField',
                    filters:{pfiltro:'sad.cuenta_contable',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'monto_partida',
                        fieldLabel: 'Monto Partida',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:red; ">{0}</b>', Ext.util.Format.number(record.data['monto_partida'],'0,000.00'));
                            //String.format('<div style="color:green; text-align:right; font-weight:bold;"><b>{0}</b></div>', Ext.util.Format.number(value,'0,000.00'));
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.monto_partida',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'tipo_doc_rdo',
                        fieldLabel: 'Tipo Doc. Respaldo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:gray; ">{0}</b>', record.data['tipo_doc_rdo']);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.tipo_doc_rdo',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'nro_doc_rdo',
                        fieldLabel: 'Nro. Doc. Respaldo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:gray; ">{0}</b>', record.data['nro_doc_rdo']);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.nro_doc_rdo',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'sec_doc_rdo',
                        fieldLabel: 'Sec. Doc. Respaldo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:gray; ">{0}</b>', record.data['sec_doc_rdo']);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'sad.sec_doc_rdo',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_elaboracion',
                        fieldLabel: 'Fecha Elaboracion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function(value, p, record){
                            return String.format('<b style="color:gray; ">{0}</b>', record.data['fecha_elaboracion']);
                        },
                        renderer:function (value,p,record){
                            return value?value.dateFormat('d/m/Y'):''
                        }
                    },
                    type:'DateField',
                    filters:{pfiltro:'sad.fecha_elaboracion',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'justificacion',
                        fieldLabel: 'Resumen Operacion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300,
                        renderer: function(value, p, record){
                            return String.format('<div title="Resumen: {1}"><b><font color="grey">{0}</font></b></div>', value, record.data.justificacion);
                        }

                    },
                    type:'TextField',
                    filters:{pfiltro:'sad.justificacion',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'id_fuente',
                        fieldLabel: 'fuente',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:gray; ">{0}</b>', record.data['id_fuente']);
                        }

                    },
                    type:'TextField',
                    filters:{pfiltro:'sad.id_fuente',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'id_organismo',
                        fieldLabel: 'Organismo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:gray; ">{0}</b>', record.data['id_organismo']);
                        }

                    },
                    type:'TextField',
                    filters:{pfiltro:'sad.id_organismo' ,type:'string'},
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
                    filters:{pfiltro:'sad.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'sad.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'sad.usuario_ai',type:'string'},
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
                        name: 'cod_multa',
                        fieldLabel: 'Tipo Multa',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.cod_multa',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'multa',
                        fieldLabel: 'Multas',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:darkblue; ">{0}</b>', Ext.util.Format.number(record.data['multa'],'0,000.00'));
                            //String.format('<div style="color:green; text-align:right; font-weight:bold;"><b>{0}</b></div>', Ext.util.Format.number(value,'0,000.00'));
                        }
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.multa',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'retencion',
                        fieldLabel: 'Retenciones',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:darkblue; ">{0}</b>', Ext.util.Format.number(record.data['retencion'],'0,000.00'));
                            //String.format('<div style="color:green; text-align:right; font-weight:bold;"><b>{0}</b></div>', Ext.util.Format.number(value,'0,000.00'));
                        }
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.retencion',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'liquido_pagable',
                        fieldLabel: 'Liquido Pagable',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:red; ">{0}</b>', Ext.util.Format.number(record.data['liquido_pagable'],'0,000.00'));
                            //String.format('<div style="color:green; text-align:right; font-weight:bold;"><b>{0}</b></div>', Ext.util.Format.number(value,'0,000.00'));
                        }
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.liquido_pagable',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'beneficiario',
                        fieldLabel: 'Beneficiario',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.beneficiario',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'banco_benef',
                        fieldLabel: 'Banco Beneficiario',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.banco_benef',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'cuenta_benef',
                        fieldLabel: 'Cuenta Beneficiario',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.cuenta_benef',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'monto_benef',
                        fieldLabel: 'MontoMo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650,
                        renderer: function(value, p, record){
                            return String.format('<b style="color:red; ">{0}</b>', Ext.util.Format.number(record.data['monto_benef'],'0,000.00'));
                            //String.format('<div style="color:green; text-align:right; font-weight:bold;"><b>{0}</b></div>', Ext.util.Format.number(value,'0,000.00'));
                        }
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.monto_benef',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'banco_origen',
                        fieldLabel: 'Banco Entidad',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.banco_origen',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'cta_origen',
                        fieldLabel: 'Cuenta Entidad',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.cta_origen',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'libreta_origen',
                        fieldLabel: 'Libreta Entidad',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'sad.libreta_origen',type:'string'},
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
                    filters:{pfiltro:'sad.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'Datos C31 Sigep Adquisiciones',
            ActSave:'../../sis_sigep/control/SigepAdqDet/insertarSigepAdqDet',
            ActDel:'../../sis_sigep/control/SigepAdqDet/eliminarSigepAdqDet',
            ActList:'../../sis_sigep/control/SigepAdqDet/listarSigepAdqDet',
            id_store:'id_sigep_adq_det',
            fields: [
                {name:'id_sigep_adq_det', type: 'numeric'},
                {name:'id_sigep_adq', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'gestion', type: 'numeric'},
                {name:'clase_gasto_cip', type: 'numeric'},
                {name:'moneda', type: 'numeric'},
                {name:'total_autorizado_mo', type: 'numeric'},
                {name:'id_ptogto', type: 'numeric'},
                {name:'monto_partida', type: 'numeric'},
                {name:'tipo_doc_rdo', type: 'numeric'},
                {name:'nro_doc_rdo', type: 'numeric'},
                {name:'sec_doc_rdo', type: 'numeric'},
                {name:'fecha_elaboracion', type: 'date',dateFormat:'Y-m-d'},
                {name:'justificacion', type: 'string'},
                {name:'id_fuente', type: 'string'},
                {name:'id_organismo', type: 'string'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'beneficiario', type: 'string'},
                {name:'banco_benef', type: 'string'},
                {name:'cuenta_benef', type: 'string'},
                {name:'banco_origen', type: 'string'},
                {name:'cta_origen', type: 'string'},
                {name:'libreta_origen', type: 'string'},
                {name:'monto_benef', type: 'numeric'},
                {name:'multa', type: 'numeric'},
                {name:'retencion', type: 'numeric'},
                {name:'liquido_pagable', type: 'numeric'},
                {name:'cuenta_contable', type: 'varchar'},
                {name:'sisin', type: 'varchar'},
                {name:'otfin', type: 'varchar'},

            ],
            sortInfo:{
                field: 'id_sigep_adq_det',
                direction: 'ASC'
            },
            bdel:false,
            bsave:false,
            btest:false,
            bnew:false,
            bedit:false,
            onButtonReenviar: function() {
                Phx.CP.loadingShow();
                //var estadoHijo = Phx.CP.getPagina(this.id_sigep_adq_det).getSelectedData();
                var d = this.sm.getSelected().data;
                console.log('probando SIGEP:',d.id_sigep_adq_det);
                Ext.Ajax.request({
                    url:'../../sis_sigep/control/SigepAdq/ReenviarC31',
                    params:{id_sigep_adq_det:d.id_sigep_adq_det},
                    success:this.successAnularDetAcm,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
                console.log('EL DATO ES:',d);
            },
            onReloadPage: function(m){
                this.maestro=m;
                this.store.baseParams={id_sigep_adq:this.maestro.id_sigep_adq};
                this.load({params:{start:0, limit:50}});//this.bloquearMenus();
            },
            loadValoresIniciales: function(){
                this.Cmp.id_sigep_adq.setValue(this.maestro.id_sigep_adq);
                Phx.vista.SigepAdqDet.superclass.loadValoresIniciales.call(this);

            },
        }
    )
</script>

