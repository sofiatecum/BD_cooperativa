CREATE PROCEDURE CalcularYAbonarIntereses()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cuentaId INT;
    DECLARE saldo DECIMAL(12,2);
    DECLARE porcentaje DECIMAL(5,2);
    DECLARE cur CURSOR FOR
        SELECT id_cuenta_ahorro, saldo
        FROM cuentas_ahorro;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Abrimos el cursor para iterar por las cuentas de ahorro
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO cuentaId, saldo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Obtener el porcentaje de interés correspondiente
        SELECT porcentaje
        INTO porcentaje
        FROM porcentajes_intereses
        WHERE tipo_cuenta = 'AHORRO' -- Este valor puede variar según tu configuración
          AND CURRENT_DATE <= fecha_vigencia
        ORDER BY fecha_vigencia DESC
        LIMIT 1;

        -- Calcular los intereses
        SET saldo = saldo + (saldo * porcentaje / 100);

        -- Actualizar el saldo de la cuenta de ahorro
        UPDATE cuentas_ahorro
        SET saldo = saldo
        WHERE id_cuenta_ahorro = cuentaId;
    END LOOP;

    -- Cerramos el cursor
    CLOSE cur;
END
