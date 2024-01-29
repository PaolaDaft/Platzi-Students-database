SELECT *, AVG(colegiatura) OVER (PARTITION BY carrera_id) --Segun entiendo la partición seria como el SELF JOIN 
FROM platzi.alumnos;

SELECT *, AVG(colegiatura) OVER () --Aquí por default toma como partición toda la tabla
FROM platzi.alumnos;

SELECT *, SUM(colegiatura) OVER (ORDER BY colegiatura) --Lap partición la hacer sobre arriba o iguales al actual 
FROM platzi.alumnos;

SELECT *, SUM(colegiatura) OVER (PARTITION BY carrera_id ORDER BY colegiatura)  
FROM platzi.alumnos;

SELECT *, RANK() OVER (PARTITION BY carrera_id ORDER BY colegiatura DESC) --colegiatura más alta
FROM platzi.alumnos;

SELECT *, RANK() OVER (PARTITION BY carrera_id ORDER BY colegiatura DESC) AS brand_rank 
FROM platzi.alumnos
ORDER BY carrera_id, brand_rank;

SELECT *, RANK() OVER (PARTITION BY carrera_id ORDER BY colegiatura DESC) AS brand_rank  --Las window functions corren al final de todo, a esepción de ORDRE BY
FROM platzi.alumnos
WHERE brand_rank < 3 -- Esto da un error, aun no sabe que es 'brand_rank', acá conviene mejor un subquery -> como le hicimos en la clase de DUPLICADOS
ORDER BY carrera_id, brand_rank;

SELECT *
FROM ( 
	SELECT *, RANK() OVER (PARTITION BY carrera_id ORDER BY colegiatura DESC) AS brand_rank 
	FROM platzi.alumnos --Como la partition esta en la subconsulta ya al reconoce query al final
) AS ranked_colegiatura_por_carrera
WHERE brand_rank < 3  
ORDER BY carrera_id, brand_rank;