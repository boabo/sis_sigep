CREATE OR REPLACE FUNCTION sigep.ft_organismo_financiador_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_organismo_financiador_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.torganismo_financiador'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        30-08-2017 15:25:07
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'sigep.ft_organismo_financiador_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_ORG_FIN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:25:07
	***********************************/

	if(p_transaccion='SIGEP_ORG_FIN_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						org_fin.id_organismo_financiador,
                        org_fin.id_cp_organismo_fin,
						org_fin.estado_reg,
						org_fin.desc_organismo,
						org_fin.sigla_organismo,
						org_fin.organismo,
						org_fin.id_organismo,
						org_fin.fecha_reg,
						org_fin.usuario_ai,
						org_fin.id_usuario_reg,
						org_fin.id_usuario_ai,
						org_fin.id_usuario_mod,
						org_fin.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tg.gestion,
                        org_fin.id_gestion,
                        tof.descripcion as desc_organismo_fin
						from sigep.torganismo_financiador org_fin
						inner join segu.tusuario usu1 on usu1.id_usuario = org_fin.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = org_fin.id_usuario_mod
                        inner join param.tgestion tg on tg.id_gestion = org_fin.id_gestion
                        left join pre.tcp_organismo_fin tof on tof.id_cp_organismo_fin = org_fin.id_cp_organismo_fin
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ORG_FIN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		30-08-2017 15:25:07
	***********************************/

	elsif(p_transaccion='SIGEP_ORG_FIN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_organismo_financiador)
					    from sigep.torganismo_financiador org_fin
					    inner join segu.tusuario usu1 on usu1.id_usuario = org_fin.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = org_fin.id_usuario_mod
                        inner join param.tgestion tg on tg.id_gestion = org_fin.id_gestion
                        left join pre.tcp_organismo_fin tof on tof.id_cp_organismo_fin = org_fin.id_cp_organismo_fin
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	else

		raise exception 'Transaccion inexistente';

	end if;

EXCEPTION

	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;