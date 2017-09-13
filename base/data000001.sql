/********************************************I-DAT-FEA-SIGEP-0-11/09/2017********************************************/

select pxp.f_insert_tgui ('<i class="fa fa-codepen fa-2x"></i> INTEGRACION SIGEP', '', 'sigep', 'si', 1, '', 1, '', '', 'SIGEP');

select pxp.f_insert_tgui ('Clasificadores Presupuestarios', 'Clasificadores Presupuestarios', 'CLPR', 'si', 1, '', 2, '', '', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-puzzle-piece fa-2x"></i> Entidades', 'Entidades', 'ENTIDAD', 'si', 1, 'sis_sigep/vista/entidad/Entidad.php', 2, '', 'Entidad', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-line-chart fa-2x"></i> Fuentes de Financiamiento', 'Fuentes de Financiamiento', 'FUE_FIN', 'si', 2, 'sis_sigep/vista/fuente_financiamiento/FuenteFinanciamiento.php', 2, '', 'FuenteFinanciamiento', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-bank fa-2x"></i> Organismos Financiadores', 'Organismo Financiador', 'ORG_FIN', 'si', 3, 'sis_sigep/vista/organismo_financiador/OrganismoFinanciador.php', 2, '', 'OrganismoFinanciador', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-bitcoin fa-2x"></i> Objetos de Gasto', 'Objetos de Gasto', 'OBJ_GAS', 'si', 4, 'sis_sigep/vista/objeto_gasto/ObjetoGasto.php', 2, '', 'ObjetoGasto', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-group fa-2x"></i>Direcciones Administrativas', 'Direcciones Administrativas', 'DIRADM', 'si', 5, 'sis_sigep/vista/direccion_administrativa/DireccionAdministrativa.php', 3, '', 'DireccionAdministrativa', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-cogs fa-2x"></i>Unidades Ejecutoras', 'Unidades Ejecutoras', 'UE', 'si', 6, 'sis_sigep/vista/unidad_ejecutora/UnidadEjecutora.php', 3, '', 'UnidadEjecutora', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-folder fa-2x"></i>Programas', 'Programas', 'PROGRAM', 'si', 7, 'sis_sigep/vista/programa/Programa.php', 3, '', 'Programa', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-folder-open-o fa-2x"></i>Proyectos y Actividades', 'Proyectos y Actividades', 'PROACT', 'si', 8, 'sis_sigep/vista/proyecto_actividad/ProyectoActividad.php', 3, '', 'ProyectoActividad', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-folder-o fa-2x"></i>Catalogo de Proyectos', 'Catalogo Proyectos', 'CATPROY', 'si', 9, 'sis_sigep/vista/catalogo_proyecto/CatalogoProyecto.php', 3, '', 'CatalogoProyecto', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-money fa-2x"></i>Presupuestos de Gasto', 'Presupuestos de Gasto', 'PREGAS', 'si', 10, 'sis_sigep/vista/presupuesto_gasto/PresupuestoGasto.php', 3, '', 'PresupuestoGasto', 'SIGEP');



select pxp.f_insert_tgui ('Clasificadores No Presupuestarios', 'Clasificadores No Presupuestarios', 'CLNPR', 'si', 2, '', 2, '', '', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-folder-o fa-2x"></i>Documentos de Respaldo', 'Documentos de Respaldo', 'DDR', 'si', 1, 'sis_sigep/vista/documento_respaldo/DocumentoRespaldo.php', 3, '', 'DocumentoRespaldo', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-money fa-2x"></i>Clases de Gasto Con Imputación Presupuestaria ', 'Clases de Gasto Con Imputación Presupuestaria ', 'CGCIP', 'si', 2, 'sis_sigep/vista/clase_gasto_cip/ClaseGastoCip.php', 3, '', 'ClaseGastoCip', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-money fa-2x"></i>Clases de Gasto Sin Imputación Presupuestaria ', 'Clases de Gasto Sin Imputación Presupuestaria ', 'CGSIP', 'si', 3, 'sis_sigep/vista/clase_gasto_sip/ClaseGastoSip.php', 3, '', 'ClaseGastoSip', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-credit-card fa-2x"></i>Acreedores', 'Acreedores', 'ACRE', 'si', 5, 'sis_sigep/vista/acreedor/Acreedor.php', 3, '', 'Acreedor', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-diamond fa-2x"></i>Monedas', 'Monedas', 'MON', 'si', 6, 'sis_sigep/vista/moneda/Moneda.php', 3, '', 'Moneda', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-bank fa-2x"></i>Bancos', 'Bancos', 'BAN', 'si', 7, 'sis_sigep/vista/banco/Banco.php', 3, '', 'Banco', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-bank fa-2x"></i>Cuentas Bancarias', 'Cuentas Bancarias', 'CUEBAN', 'si', 8, 'sis_sigep/vista/cuenta_bancaria/CuentaBancaria.php', 3, '', 'CuentaBancaria', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-tablet fa-2x"></i>Libretas', 'Libretas', 'LIBR', 'si', 9, 'sis_sigep/vista/libreta/Libreta.php', 3, '', 'Libreta', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-qrcode fa-2x"></i>Matriz Control Cuentas Libretas', 'Matriz Control Cuentas Libretas', 'MCCL', 'si', 10, 'sis_sigep/vista/matriz_control/MatrizControl.php', 3, '', 'MatrizControl', 'SIGEP');


select pxp.f_insert_tgui ('Clasificadores Contables', 'Clasificadores Contables', 'CLACON', 'si', 3, '', 2, '', '', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-bank fa-2x"></i>Cuentas Contables', 'Cuentas Contables', 'CUECON', 'si', 1, 'sis_sigep/vista/cuenta_contable/CuentaContable.php', 3, '', 'CuentaContable', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-retweet fa-2x"></i>SIGADE', 'SIGADE', 'SIGADE', 'si', 2, 'sis_sigep/vista/sigade/Sigade.php', 3, '', 'Sigade', 'SIGEP');
select pxp.f_insert_tgui ('<i class="fa fa-random fa-2x"></i>OTFIN', 'OTFIN', 'OTFIN', 'si', 3, 'sis_sigep/vista/otfin/Otfin.php', 3, '', 'Otfin', 'SIGEP');

/*******************************************F-DAT-FEA-SIGEP-0-11/09/2017***********************************************/