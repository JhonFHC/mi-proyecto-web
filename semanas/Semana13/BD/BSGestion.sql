-- 1. CREAR BASE DE DATOS
DROP DATABASE IF EXISTS sistema_evaluacion_tesis;
CREATE DATABASE sistema_evaluacion_tesis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sistema_evaluacion_tesis;

-- 2. TABLA USUARIOS
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    codigo_upla VARCHAR(10) UNIQUE NOT NULL,
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol ENUM('estudiante', 'asesor', 'jurado', 'admin') NOT NULL,
    departamento VARCHAR(100),
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABLA TESIS
CREATE TABLE tesis (
    id_tesis INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    resumen TEXT,
    palabras_clave VARCHAR(255),
    id_estudiante INT NOT NULL,
    id_asesor INT NOT NULL,
    estado ENUM('borrador', 'enviada', 'en_evaluacion', 'aprobada', 'rechazada') DEFAULT 'borrador',
    archivo_url VARCHAR(255),
    fecha_envio TIMESTAMP NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estudiante) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_asesor) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 4. TABLA TESIS_JURADOS (Asignación)
CREATE TABLE tesis_jurados (
    id_tesis_jurado INT PRIMARY KEY AUTO_INCREMENT,
    id_tesis INT NOT NULL,
    id_jurado INT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_tesis) REFERENCES tesis(id_tesis) ON DELETE CASCADE,
    FOREIGN KEY (id_jurado) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    UNIQUE KEY unique_tesis_jurado (id_tesis, id_jurado)
);

-- 5. TABLA EVALUACIONES
CREATE TABLE evaluaciones (
    id_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    id_tesis INT NOT NULL,
    id_jurado INT NOT NULL,
    calificacion_final DECIMAL(4,2),
    comentarios TEXT,
    fecha_evaluacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'en_progreso', 'completada') DEFAULT 'pendiente',
    recomendacion ENUM('aprobado', 'aprobado_obs', 'desaprobado'),
    FOREIGN KEY (id_tesis) REFERENCES tesis(id_tesis) ON DELETE CASCADE,
    FOREIGN KEY (id_jurado) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 6. TABLA CRITERIOS_EVALUACION (LOS 38 CRITERIOS)
CREATE TABLE criterios_evaluacion (
    id_criterio INT PRIMARY KEY AUTO_INCREMENT,
    numero INT NOT NULL,
    seccion VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    peso DECIMAL(3,2) DEFAULT 1.0,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    UNIQUE KEY unique_numero (numero)
);

-- 7. TABLA DETALLE_EVALUACIONES (Puntajes por criterio)
CREATE TABLE detalle_evaluaciones (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_evaluacion INT NOT NULL,
    id_criterio INT NOT NULL,
    puntaje DECIMAL(3,2) NOT NULL CHECK (puntaje IN (0.0, 0.5, 1.0)),
    comentario TEXT,
    FOREIGN KEY (id_evaluacion) REFERENCES evaluaciones(id_evaluacion) ON DELETE CASCADE,
    FOREIGN KEY (id_criterio) REFERENCES criterios_evaluacion(id_criterio) ON DELETE CASCADE,
    UNIQUE KEY unique_evaluacion_criterio (id_evaluacion, id_criterio)
);

-- 8. INSERTAR LOS 38 CRITERIOS
INSERT INTO criterios_evaluacion (numero, seccion, descripcion) VALUES
(1, 'TÍTULO', 'El título es claro, preciso y refleja el contenido de la investigación'),
(2, 'RESUMEN/ABSTRACT', 'El resumen incluye objetivo, metodología, resultados y conclusiones'),
(3, 'RESUMEN/ABSTRACT', 'No excede las 250 palabras y contiene palabras clave'),
(4, 'INTRODUCCIÓN', 'Presenta el problema, justificación y objetivos de manera clara'),
(5, 'PROBLEMA', 'El problema de investigación está claramente formulado'),
(6, 'PROBLEMA', 'Es relevante y factible de investigar'),
(7, 'JUSTIFICACIÓN', 'Explica la importancia teórica de la investigación'),
(8, 'JUSTIFICACIÓN', 'Explica la importancia práctica de la investigación'),
(9, 'JUSTIFICACIÓN', 'Explica la importancia metodológica de la investigación'),
(10, 'OBJETIVOS', 'Los objetivos generales y específicos son claros'),
(11, 'OBJETIVOS', 'Los objetivos son alcanzables y medibles'),
(12, 'ASPECTOS ÉTICOS', 'Considera los aspectos éticos de la investigación'),
(13, 'MARCO TEÓRICO', 'Presenta los antecedentes relevantes'),
(14, 'MARCO TEÓRICO', 'Incluye las bases teóricas actualizadas'),
(15, 'MARCO TEÓRICO', 'Define los conceptos clave'),
(16, 'MARCO TEÓRICO', 'Presenta las relaciones entre variables'),
(17, 'HIPÓTESIS', 'Las hipótesis son claras y comprobables'),
(18, 'VARIABLES', 'Las variables están claramente definidas'),
(19, 'VARIABLES', 'Las variables son operacionalizadas adecuadamente'),
(20, 'METODOLOGÍA', 'El diseño de investigación es apropiado'),
(21, 'METODOLOGÍA', 'La población y muestra están bien definidas'),
(22, 'METODOLOGÍA', 'Los criterios de inclusión/exclusión son claros'),
(23, 'METODOLOGÍA', 'Las técnicas de recolección son adecuadas'),
(24, 'METODOLOGÍA', 'Los instrumentos son válidos y confiables'),
(25, 'METODOLOGÍA', 'El procedimiento de recolección es claro'),
(26, 'METODOLOGÍA', 'El plan de análisis de datos es adecuado'),
(27, 'METODOLOGÍA', 'Considera aspectos de validez y confiabilidad'),
(28, 'METODOLOGÍA', 'Considera limitaciones y sesgos'),
(29, 'RESULTADOS', 'Los resultados se presentan de manera clara'),
(30, 'RESULTADOS', 'Usa tablas y figuras apropiadas'),
(31, 'ANÁLISIS Y DISCUSIÓN', 'Analiza los resultados adecuadamente'),
(32, 'ANÁLISIS Y DISCUSIÓN', 'Discute los resultados con la teoría'),
(33, 'CONCLUSIONES', 'Las conclusiones responden a los objetivos'),
(34, 'RECOMENDACIONES', 'Las recomendaciones son pertinentes'),
(35, 'REFERENCIAS BIBLIOGRÁFICAS', 'Usa formato APA actualizado'),
(36, 'ANEXOS', 'Los anexos son relevantes y necesarios'),
(37, 'ASPECTOS DE FORMA', 'Sigue las normas de presentación'),
(38, 'ASPECTOS DE FORMA', 'Presenta buena redacción y ortografía');

-- 9. INSERTAR USUARIOS DE PRUEBA (CONTRASEÑAS ENCRIPTADAS)
INSERT INTO usuarios (codigo_upla, nombre_completo, email, password, rol, departamento) VALUES
-- Admin
('a00001a', 'Administrador Principal', 'admin@upla.edu.pe', 'admin123', 'admin', 'Administración'),
-- Estudiante
('e12345a', 'Juan Pérez López', 'e12345a@ms.upla.edu.pe', 'est123', 'estudiante', 'Ingeniería Civil'),
-- Asesor
('p23456b', 'Dr. Carlos Mendoza Ruiz', 'p23456b@ms.upla.edu.pe', 'prof123', 'asesor', 'Ingeniería Civil'),
-- Jurados
('j34567c', 'Dra. María González Silva', 'j34567c@ms.upla.edu.pe', 'prof123', 'jurado', 'Ingeniería Civil'),
('j45678d', 'Mg. Pedro Torres Vargas', 'j45678d@ms.upla.edu.pe', 'prof123', 'jurado', 'Ingeniería Civil'),
('j56789e', 'Dr. Ana López Castillo', 'j56789e@ms.upla.edu.pe', 'prof123', 'jurado', 'Ingeniería Civil');

-- 10. INSERTAR TESIS DE PRUEBA
INSERT INTO tesis (titulo, descripcion, resumen, palabras_clave, id_estudiante, id_asesor, estado, archivo_url, fecha_envio) VALUES
('Implementación de sistema de gestión de agua', 'Sistema para mejorar gestión de agua potable en zonas urbanas', 'Este estudio propone un sistema integrado para la gestión eficiente de recursos hídricos...', 'agua, gestión, sistema, ingeniería civil', 2, 3, 'en_evaluacion', 'tesis_1.pdf', NOW()),
('Estudio de algoritmos de machine learning', 'Comparativa de algoritmos de ML para predicción de datos', 'Investigación sobre la efectividad de diferentes algoritmos de machine learning en problemas de clasificación...', 'machine learning, algoritmos, IA, clasificación', 2, 3, 'enviada', 'tesis_2.pdf', NOW());

-- 11. ASIGNAR JURADOS A TESIS 1
INSERT INTO tesis_jurados (id_tesis, id_jurado) VALUES 
(1, 4), 
(1, 5), 
(1, 6);

-- 12. CREAR EVALUACIONES INICIALES
INSERT INTO evaluaciones (id_tesis, id_jurado, estado) VALUES 
(1, 4, 'pendiente'),
(1, 5, 'pendiente'),
(1, 6, 'pendiente');

-- 13. CREAR ÍNDICES PARA MEJORAR RENDIMIENTO
CREATE INDEX idx_tesis_estudiante ON tesis(id_estudiante);
CREATE INDEX idx_tesis_asesor ON tesis(id_asesor);
CREATE INDEX idx_tesis_estado ON tesis(estado);
CREATE INDEX idx_evaluaciones_tesis ON evaluaciones(id_tesis);
CREATE INDEX idx_evaluaciones_jurado ON evaluaciones(id_jurado);
CREATE INDEX idx_detalle_evaluacion ON detalle_evaluaciones(id_evaluacion);