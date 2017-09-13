CREATE OR REPLACE FUNCTION sigep.ft_acreedor_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Integracion SIGEP
 FUNCION: 		sigep.ft_acreedor_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigep.tacreedor'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        07-09-2017 16:04:47
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

	v_nombre_funcion = 'sigep.ft_acreedor_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SIGEP_ACREE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:04:47
	***********************************/

	if(p_transaccion='SIGEP_ACREE_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						acree.id_acreedor,
						acree.acreedor,
						acree.id_afp,
						acree.de_ley,
						acree.desc_acreedor,
						acree.tipo_acreedor,
						acree.estado_reg,
						acree.id_tipo_obligacion_columna,
						acree.id_usuario_ai,
						acree.id_usuario_reg,
						acree.usuario_ai,
						acree.fecha_reg,
						acree.fecha_mod,
						acree.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        (''(''||tto.codigo||'') - ''||tto.nombre)::varchar as desc_obligacion_col,
                        (''(''||coalesce(taf.codigo,''s/c'')||'') - ''||taf.nombre)::varchar as desc_afp
						from sigep.tacreedor acree
						inner join segu.tusuario usu1 on usu1.id_usuario = acree.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = acree.id_usuario_mod
                        left join plani.ttipo_obligacion_columna toc on toc.id_tipo_obligacion_columna =  acree.id_tipo_obligacion_columna
                        left join plani.ttipo_obligacion tto on tto.id_tipo_obligacion = toc.id_tipo_obligacion
                        left join plani.tafp taf on taf.id_afp = acree.id_afp
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice 'v_consulta: %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SIGEP_ACREE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:04:47
	***********************************/

	elsif(p_transaccion='SIGEP_ACREE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_acreedor)
					    from sigep.tacreedor acree
					    inner join segu.tusuario usu1 on usu1.id_usuario = acree.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = acree.id_usuario_mod
                        left join plani.ttipo_obligacion_columna toc on toc.id_tipo_obligacion_columna =  acree.id_tipo_obligacion_columna
                        inner join plani.ttipo_obligacion tto on tto.id_tipo_obligacion = toc.id_tipo_obligacion
                        left join plani.tafp taf on taf.id_afp = acree.id_afp
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'SIGEP_OB_COL_SEL'
 	#DESCRIPCION:	Consulta de datos obligacion columna
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:04:47
	***********************************/

	elseif(p_transaccion='SIGEP_OB_COL_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						toc.id_tipo_obligacion_columna,
						toc.codigo_columna,
                        tto.id_tipo_obligacion,
						tto.codigo,
						tto.nombre
						from plani.ttipo_obligacion_columna toc
                        inner join plani.ttipo_obligacion tto on tto.id_tipo_obligacion = toc.id_tipo_obligacion
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
		end;
    /*********************************
 	#TRANSACCION:  'SIGEP_ACREE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		07-09-2017 16:04:47
	***********************************/

	elsif(p_transaccion='SIGEP_OB_COL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(toc.id_tipo_obligacion_columna)
					    from plani.ttipo_obligacion_columna toc
                        inner join plani.ttipo_obligacion tto on tto.id_tipo_obligacion = toc.id_tipo_obligacion
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