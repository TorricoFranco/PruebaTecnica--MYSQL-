DROP DATABASE IF EXISTS escuela_musica_db;
CREATE DATABASE escuela_musica_db;
use escuela_musica_db;

DROP TABLE IF EXISTS alumnos;

CREATE TABLE alumnos (
	id_alumno INT PRIMARY KEY,
    apellido VARCHAR(35),
    nombre VARCHAR(35),
	fecha_nac DATE,
    direccion VARCHAR(35),
	telefono VARCHAR(15),
    email VARCHAR(25)

);

DROP TABLE IF EXISTS cursos;

CREATE TABLE cursos (
	id_curso INT PRIMARY KEY,
    nombre VARCHAR(50),
    nivel_habilidad VARCHAR(25),
    tipo_instrumento VARCHAR(25)
);

DROP TABLE IF EXISTS incripciones;

CREATE TABLE inscripciones (
 id_inscripcion int PRIMARY KEY,
 fecha_insc DATE,
 abono_insc BOOLEAN,
 id_alumno INT,
 id_curso INT,
 FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
 FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);


-- INSERTS

INSERT INTO `alumnos` (`id_alumno`, `apellido`, `nombre`, `fecha_nac`, `direccion`, `telefono`, `email`) VALUES
(1, 'Perez', 'Juan', '1996-06-10', 'Calle Falsa 123', '123456789', 'juan.perez@example.com'),
(2, 'Gonzalez', 'Maria', '1999-03-20', 'Avenida Siempre Viva 742', '987654321', 'maria.gonzalez@example.co'),
(3, 'Lopez', 'Carlos', '1990-11-21', 'Calle Principal 456', '456123789', 'carlos.lopez@example.com'),
(4, 'Martinez', 'Ana', '1991-11-23', 'Calle Secundaria 789', '789123456', 'ana.martinez@example.com'),
(5, 'Fernandez', 'Lucia', '1995-05-04', 'Calle Tercera 321', '321654987', 'lucia.fernandez@example.c'),
(6, 'Hola', 'Carlita', '2001-12-25', 'Calle Cuarta 654', '654987321', 'diego.sanchez@example.com');


INSERT INTO cursos (id_curso, nombre, nivel_habilidad, tipo_instrumento) VALUES
(1, 'Guitarra Principiante', 'Principiante', 'Guitarra'),
(2, 'Guitarra Intermedio', 'Intermedio', 'Guitarra'),
(3, 'Guitarra Avanzado', 'Avanzado', 'Guitarra'),
(4, 'Piano Principiante', 'Principiante', 'Piano'),
(5, 'Piano Intermedio', 'Intermedio', 'Piano'),
(6, 'Piano Avanzado', 'Avanzado', 'Piano'),
(7, 'Violín Principiante', 'Principiante', 'Violín'),
(8, 'Violín Intermedio', 'Intermedio', 'Violín'),
(9, 'Violín Avanzado', 'Avanzado', 'Violín');


INSERT INTO inscripciones (id_inscripcion, fecha_insc, abono_insc, id_alumno, id_curso) VALUES
(1, '2025-01-05', TRUE, 1, 1),
(2, '2024-01-10', FALSE, 2, 2),
(3, '2024-02-15', TRUE, 3, 3),
(4, '2024-03-20', FALSE, 4, 4),
(5, '2024-04-25', TRUE, 5, 5),
(6, '2024-05-30', FALSE, 6, 6),
(7, '2024-01-15', TRUE, 1, 2),
(8, '2024-02-10', TRUE, 2, 3),
(9, '2024-03-05', FALSE, 3, 1),
(10, '2024-04-01', TRUE, 4, 6),
(11, '2024-05-05', FALSE, 5, 4),
(12, '2024-06-01', TRUE, 6, 9),
(13, '2024-01-20', FALSE, 1, 5),
(14, '2024-02-25', TRUE, 2, 7),
(15, '2024-03-30', FALSE, 3, 8);

-- CONSTULTAS

-- LISTAR TODOS LOS ALUMNOS INSCRIPTOS EN EL CURSO DE "GUITARRA INTERMEDIO"

SELECT a.nombre, a.apellido
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN cursos c ON c.id_curso = i.id_curso
AND c.nivel_habilidad = "intermedio"
AND c.tipo_instrumento = "guitarra"
;


-- MOSTRAR TODAS LAS INSCRIPCIONES REALIZADAS DESPUES DEL 1 DE ENERO DE 2024

SELECT * FROM inscripciones
WHERE fecha_insc > "2024-1-1"
ORDER BY fecha_insc DESC
;


-- CONTAR LA CANTIDAD DE INSCRIPCIONES ABONADAS

SELECT COUNT(abono_insc) AS num_insc_abonadas
FROM inscripciones
WHERE abono_insc = 1;
;

-- LISTAR LOS CURSOS DE NIVEL AVANZADO

SELECT COUNT(nivel_habilidad) AS num_cursos_avanzados
FROM cursos
WHERE nivel_habilidad = "avanzado"
GROUP BY nivel_habilidad
;

-- LISTAR LOS NOMBRES Y APELLIDOS DE LOS ALUMNOS JUNTO CON LOS NOMBRES DE LOS CURSOS A LO QUE ESTAN INSCRIPTOS

SELECT a.nombre, a.apellido, c.nombre
FROM inscripciones i
JOIN alumnos a
ON a.id_alumno = i.id_alumno
JOIN cursos c
ON c.id_curso = i.id_curso
;

-- OBTENER EL NOMBRE Y APELLIDO DE LOS ALUMNOS QUE ESTA INSCRITOS EN MÁS DE UN CURSO

SELECT a.nombre, a.apellido, COUNT(*) AS cursos_inscriptos
FROM inscripciones i
JOIN alumnos a
ON a.id_alumno = i.id_alumno	
JOIN cursos c
ON c.id_curso = i.id_curso
GROUP BY a.id_alumno
having cursos_inscriptos > 1
;

-- Mostrar el nombre de cada curso y la cantidad de alumnos inscriptos en cada uno

SELECT c.nombre ,COUNT(a.nombre) AS cant_alumnos
FROM inscripciones i
JOIN cursos c
ON c.id_curso = i.id_curso
JOIN alumnos a
ON a.id_alumno = i.id_alumno
GROUP BY c.nombre
;

-- LISTAR LOS ALUMNOS QUE NO HAYAN ABONADO LA INSCRIPCION 

SELECT a.nombre, a.apellido
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
WHERE abono_insc = 1
;

-- OBTENER LOS NOMBRES DE LOS CURSOS QUE TIENEN AL MENOS UN ALUMNO MAYOR DE 30 AÑOS INSCRIPTOS

SELECT c.nombre
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN cursos c ON c.id_curso = i.id_curso
WHERE TIMESTAMPDIFF(YEAR, a.fecha_nac, CURDATE()) > 30
;
-- CURDATE DEVUELVE LA FECHA DE HOY SIN LA HORA


-- LISTAR EL NOMBRE Y APELLIDO DE LOS ALUMNOS JUNTO CON LOS NOMBRES DE LOS CURSOS EN LOS QUE 
-- ESTÁN INSCRIPTOS, PERO SOLO PARA AQUELLOS QUE SE INSCRIBIERON EN 2024

SELECT i.id_inscripcion, a.nombre, a.apellido, c.nombre AS curso, i.fecha_insc
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN cursos c ON c.id_curso = i.id_curso
WHERE YEAR(i.fecha_insc) = 2024;
;
