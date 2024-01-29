--- El primero
SELECT * FROM platzi.alumnos
FETCH FIRST 1 ROWS ONLY; --FETCH similar a LIMIT

SELECT * FROM platzi.alumnos
LIMIT 1;

SELECT *
FROM (
	SELECT ROW_NUMBER( ) OVER() AS row_id,*
	FROM platzi.alumnos
	)AS alumnos_with_row_num
;

SELECT *
FROM (
	SELECT ROW_NUMBER( ) OVER() AS row_id,* --ROW_NUMBER comando para las funciones ventana
	FROM platzi.alumnos
	)AS alumnos_with_row_num
WHERE row_id = 1
;


--- El segundo más alto
-- SEGUNDA COLEGATURA MÁS ALTA

SELECT DISTINCT colegiatura 
FROM platzi.alumnos AS a1
WHERE 2 = (
	SELECT COUNT (DISTINCT colegiatura) --cuenta 1x1
	FROM platzi.alumnos a2
	WHERE a1.colegiatura <= a2.colegiatura
);

SELECT DISTINCT colegiatura 
FROM platzi.alumnos 
ORDER BY colegiatura DESC
LIMIT 1 OFFSET 1;

SELECT DISTINCT colegiatura, tutor_id 
FROM platzi.alumnos 
WHERE tutor_id = 20
ORDER BY colegiatura DESC
LIMIT 1 OFFSET 1;

SELECT *
FROM platzi.alumnos AS datos_alumnos
INNER JOIN (
	SELECT DISTINCT colegiatura 
	FROM platzi.alumnos
	WHERE tutor_id = 20
	ORDER BY colegiatura DESC
	LIMIT 1 OFFSET 1
) AS segunda_mayor_colegiatura 
ON datos_alumnos.colegiatura = segunda_mayor_colegiatura.colegiatura;

SELECT *
FROM platzi.alumnos AS datos_alumnos
WHERE colegiatura = (
	SELECT DISTINCT colegiatura 
	FROM platzi.alumnos
	WHERE tutor_id = 20
	ORDER BY colegiatura DESC 
	LIMIT 1 OFFSET 1
);

---- TRAYENDO LA SEGUNDA MITAD DE LA TABLA
SELECT ROW_NUMBER( ) OVER() AS row_id, *
FROM platzi.alumnos
OFFSET (
	SELECT COUNT (*)/2 
	FROM platzi.alumnos
);


--- Seleccionar de un set de opciones
SELECT *
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row_num
WHERE row_id IN (1, 5, 10, 12, 15, 20 ); -- Estatico 


SELECT *
FROM platzi.alumnos
WHERE id IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
);

-- SELECCIONANDO LOS DATOS QUE NO SE ENCUENTRAN EN EL SET

SELECT *
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row_num
WHERE row_id NOT IN (1, 5, 10, 12, 15, 20 ); -- Estatico 


SELECT *
FROM platzi.alumnos
WHERE id NOT IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
);


--- Tiempos
-- PARA FECHAS
-- AÑO
SELECT EXTRACT(YEAR FROM fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;

SELECT DATE_PART('YEAR',fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;

--PARTIENDO LA FECHA
SELECT DATE_PART('YEAR',fecha_incorporacion) AS anio_incorporacion,
	   DATE_PART('MONTH',fecha_incorporacion) AS mes_incorporacion,
	   DATE_PART('DAY',fecha_incorporacion) AS dia_incorporacion
FROM platzi.alumnos;

--- SACANDO LAS PARTE DE LA HR
SELECT * FROM platzi.alumnos;

SELECT DATE_PART('HOUR',fecha_incorporacion) AS anio_incorporacion,
	   DATE_PART('MINUTE',fecha_incorporacion) AS mes_incorporacion,
	   DATE_PART('SECOND',fecha_incorporacion) AS dia_incorporacion
FROM platzi.alumnos;-- PARA FECHAS
-- AÑO
SELECT EXTRACT(YEAR FROM fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;

SELECT DATE_PART('YEAR',fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;

--PARTIENDO LA FECHA
SELECT DATE_PART('YEAR',fecha_incorporacion) AS anio_incorporacion,
	   DATE_PART('MONTH',fecha_incorporacion) AS mes_incorporacion,
	   DATE_PART('DAY',fecha_incorporacion) AS dia_incorporacion
FROM platzi.alumnos;

-------------- SACANDO LAS PARTE DE LA HR
SELECT * FROM platzi.alumnos;

SELECT DATE_PART('HOUR',fecha_incorporacion) AS hora_incorporacion,
	   DATE_PART('MINUTE',fecha_incorporacion) AS minut_incorporacion,
	   DATE_PART('SECOND',fecha_incorporacion) AS seg_incorporacion
FROM platzi.alumnos;


--- Seleccionar por año
-- Trayendo alumnos que se incorporaron en el 2019
SELECT *
FROM platzi.alumnos
WHERE (EXTRACT(YEAR FROM fecha_incorporacion) = 2019);
 
SELECT *
FROM platzi.alumnos 
WHERE (DATE_PART('YEAR', fecha_incorporacion) = 2019);

SELECT *
FROM (
	SELECT *, DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion
	FROM platzi.alumnos 
) AS alumnos_con_anio
WHERE anio_incorporacion = 2020;

----- ALUMNOS QUE SE INCORPORARON EN MAYO 2018
SELECT *
FROM platzi.alumnos
WHERE EXTRACT(MONTH FROM fecha_incorporacion) = 05
	AND EXTRACT(YEAR FROM fecha_incorporacion) = 2018;


--- Duplicados 
-- INDENTIFICANDOLO POR ID | Lo cual no es muy util ya que el id puede ser diferente pero la demás data igual
SELECT *
FROM platzi.alumnos AS ou
WHERE (
	SELECT COUNT(*) 
	FROM platzi.alumnos AS inr
	WHERE ou.id = inr.id
)>1;

-- Forma efectiva
SELECT (platzi.alumnos.nombre,
		platzi.alumnos.apellido,
		platzi.alumnos.email,
		platzi.alumnos.colegiatura,
		platzi.alumnos.fecha_incorporacion,
		platzi.alumnos.carrera_id,
		platzi.alumnos.tutor_id
	   )::text, -- :: es un cast convirtiendo esos datos a un text
		COUNT(*)
FROM platzi.alumnos
GROUP BY platzi.alumnos.nombre,
		platzi.alumnos.apellido,
		platzi.alumnos.email,
		platzi.alumnos.colegiatura,
		platzi.alumnos.fecha_incorporacion,
		platzi.alumnos.carrera_id,
		platzi.alumnos.tutor_id
HAVING COUNT(*)>1;

-- Otra forma usando window Functions
SELECT *
FROM (
	SELECT id,
	ROW_NUMBER() OVER(
		PARTITION BY
			nombre,
			apellido,
			email,
			colegiatura,
			fecha_incorporacion,
			carrera_id,
			tutor_id
			ORDER BY id ASC
	) AS row, 
	*	
	FROM platzi.alumnos
) AS duplicados
WHERE duplicados.row > 1;


------ ELIMINANDO EL REGISTRO DUPLICADO
DELETE FROM platzi.alumnos
WHERE id IN (
	SELECT id
	FROM (
		SELECT id,
		ROW_NUMBER() OVER(
			PARTITION BY
				nombre,
				apellido,
				email,
				colegiatura,
				fecha_incorporacion,
				carrera_id,
				tutor_id
				ORDER BY id ASC
		) AS row
		FROM platzi.alumnos
	) AS duplicados
	WHERE duplicados.row > 1
);


--- Selectores de rango
SELECT * 
FROM platzi.alumnos
WHERE tutor_id IN (1,2, 3,4);

SELECT * 
FROM platzi.alumnos
WHERE tutor_id>=1 AND tutor_id<=10;

SELECT * 
FROM platzi.alumnos
WHERE tutor_id BETWEEN 1 AND 10;

SELECT int4range(10, 20) @>3; --Si existe el 3 entre ese rango 

SELECT numrange(11.1, 22.2) && numrange(20.0, 30.0) -- Si se solapan estos dos gangos 

SELECT UPPER (int8range(15,25)); -- El no. más alto y bajo del rango
SELECT LOWER (int8range(15,25)); 

SELECT int4range(10,20) * int4range(15,25); --Intersección entre ambos rangos [15,20)

SELECT ISEMPTY(numrange(1,5));

SELECT *
FROM platzi.alumnos
WHERE int4range(10,20) @>tutor_id;

-- Intersección entre tutore_id y carrera_id
SELECT INT4RANGE(MIN(tutor_id), MAX(tutor_id)) * INT4RANGE(MIN(carrera_id), MAX(carrera_id))
FROM platzi.alumnos;


--- Máximos 
SELECT fecha_incorporación
FROM platzi.alumnos
ORDER BY fecha_incorporación DESC
LIMIT 1; -- es limitado el uso

SELECT carrera_id, MAX(fecha_incorporacion)
FROM platzi.alumnos
GROUP BY carrera_id 
ORDER BY carrera_id;

-- Mínimos con respecto al nombre y id_tutor

SELECT nombre
FROM platzi.alumnos
ORDER BY nombre ASC
LIMIT 1;

SELECT tutor_id, MIN(nombre)
FROM platzi.alumnos
GROUP BY tutor_id 
ORDER BY tutor_id;


-- Un self join | un join a la misma tabla 
SELECT a.nombre, a.apellido, --alumno
	   t.nombre, t.apellido -- tutor
FROM platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t	
	ON a.tutor_id = t.id;

SELECT CONCAT(a.nombre,' ', a.apellido) AS alumno,
	   CONCAT(t.nombre,' ', t.apellido)  tutor
FROM platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t	
	ON a.tutor_id = t.id;
	
-- Qué tutor tiene más carga de trabao? | contando no. de alumnos
SELECT CONCAT(t.nombre,' ', t.apellido)  tutor,
	COUNT(*) AS alumnos_por_tutor
FROM platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t ON a.tutor_id = t.id
GROUP BY tutor
ORDER BY alumnos_por_tutor DESC;

-- Promedio general por tutor de alumnos
SELECT CONCAT(t.nombre, ' ', t.apellido) AS tutor,
       AVG(COUNT(*)) OVER () AS promedio_de_alumnos --La cláusula OVER () indica que se debe calcular el 
	   --promedio sobre todo el conjunto de resultados, en lugar de por filas individuales.
FROM platzi.alumnos AS a
INNER JOIN platzi.alumnos AS t ON a.tutor_id = t.id
GROUP BY tutor
ORDER BY promedio_de_alumnos DESC;

	-- Otra forma
SELECT AVG(alumnos_por_tutor) AS promedio_de_alumnos_por_tutor
FROM(
	SELECT CONCAT(t.nombre,' ', t.apellido)  tutor,
		COUNT(*) AS alumnos_por_tutor
	FROM platzi.alumnos AS a
		INNER JOIN platzi.alumnos AS t ON a.tutor_id = t.id
	GROUP BY tutor
	ORDER BY alumnos_por_tutor DESC
) AS alumnos_tutor;


--- Resolviendo diferencias
-- Traer a los que cuya carrar ya no existe
SELECT a.nombre, a.apellido, a.carrera_id,
	   c.id, c.carrera
FROM platzi.alumnos AS a
LEFT JOIN platzi.carreras AS c 
	ON a.carrera_id = c.id
WHERE c.id IS  NULL
ORDER BY a.carrera_id;
	
--Traer a todos
SELECT a.nombre, a.apellido, a.carrera_id,
	   c.id, c.carrera
FROM platzi.alumnos AS a
FULL OUTER JOIN platzi.carreras AS c 
	ON a.carrera_id = c.id
ORDER BY a.carrera_id;


--- Todas las uniones
-- LEFT JOIN exclusivo
SELECT a.nombre, a.apellido, a.carrera_id,
	   c.id, c.carrera
FROM platzi.alumnos AS a
LEFT JOIN platzi.carreras AS c 
	ON a.carrera_id = c.id
WHERE c.id IS  NULL
ORDER BY a.carrera_id;
	
--RIGHT JOIN exclusivo
SELECT a.nombre, a.apellido, a.carrera_id,
	   c.id, c.carrera
FROM platzi.alumnos AS a
RIGHT JOIN platzi.carreras AS c 
	ON a.carrera_id = c.id
WHERE a.id IS  NULL
ORDER BY c.id DESC;

--FULL OUTER JOIN Diferencia simetrica | excluyendo la parte de 
SELECT a.nombre, a.apellido, a.carrera_id,
	   c.id, c.carrera
FROM platzi.alumnos AS a
FULL OUTER JOIN platzi.carreras AS c 
	ON a.carrera_id = c.id
WHERE a.id IS NULL OR c.id IS NULL
ORDER BY a.carrera_id DESC, c.id DESC;

-- FULL OUTER
SELECT a.nombre, a.apellido, a.carrera_id,
	   c.id, c.carrera
FROM platzi.alumnos AS a
LEFT JOIN platzi.carreras AS c 
	ON a.carrera_id = c.id
ORDER BY a.carrera_id;


--- Generando rangos
SELECT  *
FROM generate_series(5,1,-2); --Debemsos especificar el paso/delta | si no es especifica, va a ir de 1en1

SELECT  *
FROM generate_series(1.2,4.1,1.3);

SELECT current_date + s.a AS dates -- por default va a sumar días
FROM generate_series(0,14,7) AS s(a);

SELECT *
FROM generate_series('2020-09-01 00:00:00'::timestamp,
					 '2020-09-04 12:00:00', '10 hours');

SELECT a.id,a.nombre, a.carrera_id, s.a
FROM platzi.alumnos AS a
INNER JOIN generate_series(0,10) AS s(a)
	ON s.a = a.carrera_id
ORDER BY a.carrera_id;

--Triangulo con esta nueva función
SELECT lpad('*',generate_series(1,20),'*'); -- triangulo :)

SELECT lpad('*', CAST(ordinality AS int),'*') --ordinalidad, en este caso le da in idice 1,2,3...
FROM generate_series(100,2,-2) WITH ordinality;

SELECT * --ordinalidad
FROM generate_series(100,2,-2) WITH ordinality;

SELECT lpad('*',generate_series(100,2,-2),'*'); -- Sin la ordinalidad saldrá al reves


--- Regularizando expresiones
SELECT email
FROM platzi.alumnos
WHERE email ~*'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}'; --en SQL comienza con ~*
--Expreciones regulares = Forma contrida de hacer validanción de patrones

SELECT email
FROM platzi.alumnos
WHERE email ~*'[A-Z0-9._%+-]+@google[A-Z0-9.-]+\.[A-Z]{2,4}';
