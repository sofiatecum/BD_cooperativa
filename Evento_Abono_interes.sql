CREATE EVENT AbonoInteresAhorro
ON SCHEDULE EVERY 1 MONTH
STARTS CONCAT(DATE(DATE_ADD(NOW(), INTERVAL 1 DAY)), ' 00:00:00')
DO CALL CalcularYAbonarIntereses();