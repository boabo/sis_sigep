<?php
/**
 *@package pXP
 *@file    iFrameToken.php
 *@author  Romer Zabala
 *@date    2-09-2019
 *@description iFrame que redirecciona a la pagina de obtencion de token del Sigep
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    function resizeIframe(obj) {
        obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
    }

    Ext.define('Phx.vista.redirectSigep',{
        extend: 'Ext.util.Observable',

        constructor: function(config) {
            var me = this;
            Ext.apply(this, config);
            var me = this;
            this.callParent(arguments);


            this.panel = Ext.getCmp(this.idContenedor);

            var newIndex = 3;



            this.reportPanel = new Ext.Panel({
                id: 'reportPanel',
                width: '100%',
                height: '100%',
                /*renderTo: Ext.get('principal'),*/
                region:'center',
                margins: '5 0 5 5',
                layout: 'fit',
                closable: true,
                //autoScroll : true,
                items: [{
                    xtype: 'box',
                    width: '100%',
                    height: '100%',
                    autoEl: {
                        tag: 'iframe',
                        //http://sigeppre-wl12.sigma.gob.bo/rsseguridad/loginapi.html?redirect_uri=http://www.cliente.com.bo/recibeauth
                        src: 'https://sigeppruebas-wl12.sigma.gob.bo/rsseguridad/login.html?redirect_uri=http://10.150.0.90/kerp/sis_sigep/control/ActionInitRefreshToken.php',
                    }}]
            });


            this.Border = new Ext.Container({
                layout:'border',
                id:'principal',
                items:[this.reportPanel]
            });

            this.panel.add(this.Border);
            this.panel.doLayout();
            this.addEvents('init');

        }

    });

</script>
