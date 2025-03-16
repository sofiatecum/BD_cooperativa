USE cooperativa_db;

-- -----------------------------------
-- Crear tabla "tarjeta"
-- -----------------------------------
CREATE TABLE IF NOT EXISTS tarjeta (
    id_tarjeta INT AUTO_INCREMENT PRIMARY KEY,
    no_cuenta_monetaria INT NOT NULL,
    nombre_cliente VARCHAR(200) NOT NULL,
    id_cliente INT NOT NULL,
    fecha_creacion_tarjeta DATETIME NOT NULL,
    fecha_vencimiento TIME NOT NULL,
    cvv INT NOT NULL
);

-- -----------------------------------
-- Actualizar tabla "manejo_tarjeta"
-- -----------------------------------
ALTER TABLE manejo_tarjeta
DROP COLUMN numero_tarjeta,
DROP COLUMN tipo_tarjeta,
DROP COLUMN fecha_emision,
DROP COLUMN fecha_vencimiento,
ADD CONSTRAINT fk_manejo_tarjeta_tarjeta
FOREIGN KEY (id_tarjeta) REFERENCES tarjeta(id_tarjeta)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- -----------------------------------
-- Actualizar tabla "manejo_chequera"
-- -----------------------------------
ALTER TABLE manejo_chequera
ADD COLUMN cliente VARCHAR(200) NOT NULL,
ADD COLUMN numero_cuenta_monetaria INT NOT NULL,
ADD COLUMN fecha DATETIME NOT NULL,
ADD COLUMN numero_cheque VARCHAR(20) NOT NULL,
ADD COLUMN descripcion VARCHAR(255) DEFAULT NULL,
ADD COLUMN debito DECIMAL(10,2) DEFAULT '0.00',
ADD CONSTRAINT fk_manejo_chequera_chequera
FOREIGN KEY (id_chequera) REFERENCES chequera(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Quitar campos que ya no son necesarios
ALTER TABLE manejo_chequera
DROP COLUMN numero_chequera,
DROP COLUMN estado,
DROP COLUMN fecha_emision,
DROP COLUMN monto;

-- -----------------------------------
-- Actualizar tabla "chequera"
-- -----------------------------------
ALTER TABLE chequera
ADD COLUMN id_cliente INT NOT NULL,
ADD COLUMN fecha_emision DATETIME NOT NULL,
ADD COLUMN cliente VARCHAR(200) NOT NULL;

-- Modificar tipo de dato de "fecha_emision"
ALTER TABLE chequera;

-- Quitar campos movidos a "manejo_chequera"
ALTER TABLE chequera
DROP COLUMN fecha,
DROP COLUMN numero_cheque,
DROP COLUMN descripcion,
DROP COLUMN debito,
DROP COLUMN saldo;

ALTER TABLE clientes
ADD COLUMN tipo_cliente ENUM('individual', 'juridico') NOT NULL;

ALTER TABLE cuentas_monetarias
DROP COLUMN tarjeta_debito,
DROP COLUMN chequera,
ADD COLUMN id_cliente INT NOT NULL,
MODIFY COLUMN fecha_creacion DATETIME NOT NULL;
-- -----------------------------------
-- Nota: No se repiten aquí los cambios del script update catalogo para evitar redundancia, ya que ya se realizaron (si no se realizaron se pueden unir para usar un solo script
