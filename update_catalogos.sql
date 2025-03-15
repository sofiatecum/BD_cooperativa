-- Archivo: update_catalogs.sql

-- Seleccionar la base de datos de trabajo
USE cooperativa_db;

-- -----------------------------------
-- Creación de tablas catálogo
-- -----------------------------------

-- Catálogo para tipos de operación en operaciones bancarias
CREATE TABLE IF NOT EXISTS catalogo_tipo_operacion (
    id_tipo_operacion INT AUTO_INCREMENT PRIMARY KEY,
    tipo_operacion VARCHAR(50) NOT NULL
);

-- Insertar valores al catálogo de tipos de operación
INSERT INTO catalogo_tipo_operacion (tipo_operacion) VALUES
('DEPOSITO'), 
('RETIRO'), 
('TRANSFERENCIA'), 
('PAGO_PRÉSTAMO');

-- Catálogo para estados de préstamos
CREATE TABLE IF NOT EXISTS catalogo_estado_prestamo (
    id_estado_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    estado_prestamo VARCHAR(50) NOT NULL
);

-- Insertar valores al catálogo de estados de préstamo
INSERT INTO catalogo_estado_prestamo (estado_prestamo) VALUES
('PENDIENTE'), 
('APROBADO'), 
('PAGADO'), 
('CANCELADO');

-- Catálogo para estados generales (ejemplo: `usuarios`)
CREATE TABLE IF NOT EXISTS catalogo_estado (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50) NOT NULL
);

-- Insertar valores al catálogo de estados generales
INSERT INTO catalogo_estado (estado) VALUES
('ACTIVO'), 
('INACTIVO');

-- Catálogo para tipos de usuario (tabla `usuarios`)
CREATE TABLE IF NOT EXISTS catalogo_tipo_usuario (
    id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY,
    tipo_usuario VARCHAR(50) NOT NULL
);

-- Insertar valores al catálogo de tipos de usuario
INSERT INTO catalogo_tipo_usuario (tipo_usuario) VALUES
('SOCIO'), 
('EMPLEADO'), 
('ADMIN');

-- -----------------------------------
-- Actualización de las tablas originales
-- -----------------------------------

-- Modificar la tabla `operaciones_bancarias` para usar el catálogo
ALTER TABLE operaciones_bancarias
ADD COLUMN tipo_operacion_id INT NOT NULL AFTER tipo_operacion,
ADD FOREIGN KEY (tipo_operacion_id) REFERENCES catalogo_tipo_operacion(id_tipo_operacion),
DROP COLUMN tipo_operacion;

-- Modificar la tabla `prestamos` para usar el catálogo
ALTER TABLE prestamos
ADD COLUMN estado_id INT NOT NULL AFTER estado,
ADD FOREIGN KEY (estado_id) REFERENCES catalogo_estado_prestamo(id_estado_prestamo),
DROP COLUMN estado;

-- Modificar la tabla `usuarios` para usar los catálogos
ALTER TABLE usuarios
ADD COLUMN tipo_usuario_id INT NOT NULL AFTER tipo_usuario,
ADD FOREIGN KEY (tipo_usuario_id) REFERENCES catalogo_tipo_usuario(id_tipo_usuario),
DROP COLUMN tipo_usuario,
ADD COLUMN estado_id INT NOT NULL AFTER estado,
ADD FOREIGN KEY (estado_id) REFERENCES catalogo_estado(id_estado),
DROP COLUMN estado;

-- Modificar la tabla `cuotas_prestamos` para usar el catálogo de estados
ALTER TABLE cuotas_prestamos
ADD COLUMN estado_id INT NOT NULL AFTER estado,
ADD FOREIGN KEY (estado_id) REFERENCES catalogo_estado(id_estado),
DROP COLUMN estado;

-- Modificar la tabla `manejo_tarjeta` para usar un catálogo para estado (ejemplo adicional)
ALTER TABLE manejo_tarjeta
ADD COLUMN estado_id INT NOT NULL AFTER estado,
ADD FOREIGN KEY (estado_id) REFERENCES catalogo_estado(id_estado),
DROP COLUMN estado;
