USE coworking_db;

-- =========================================
-- EXAMEN #1 : Dashboard Básico para Recepcionista
-- Hecho por Carlos Said.
-- =========================================

-- ---------------------------------------------------------
-- 1. VISTA MEJORADA: VW_EstadoEspacios
-- Incluye la próxima reserva y la capacidad del espacio
-- ---------------------------------------------------------
DROP VIEW IF EXISTS VW_EstadoEspacios;

CREATE VIEW VW_EstadoEspacios AS
SELECT 
    e.id_espacio,
    e.codigo_espacio AS espacio,
    e.capacidad_maxima,
    -- Traduce el estado de disponibilidad
    CASE 
        WHEN e.estado_disponibilidad = 'ocupado' THEN 'Ocupado'
        WHEN e.estado_disponibilidad = 'mantenimiento' THEN 'Mantenimiento'
        ELSE 'Libre'
    END AS estado,
    -- Próxima reserva agendada para el día actual o posterior
    (
        SELECT MIN(CONCAT(r.fecha_reserva, ' ', r.hora_inicio))
        FROM reserva r
        WHERE r.id_espacio = e.id_espacio
          AND r.estado_reserva IN ('confirmada', 'pendiente')
          AND (r.fecha_reserva > CURRENT_DATE() 
               OR (r.fecha_reserva = CURRENT_DATE() AND r.hora_inicio >= CURRENT_TIME()))
    ) AS proxima_reserva
FROM espacio e;


-- ---------------------------------------------------------
-- 2. PROCEDIMIENTO ALMACENADO: sp_GenerarReporteDiario
-- Consolida reservas, accesos permitidos e ingresos de hoy
-- ---------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_GenerarReporteDiario;

DELIMITER $$

CREATE PROCEDURE sp_GenerarReporteDiario()
BEGIN
    DECLARE v_total_reservas_hoy INT DEFAULT 0;
    DECLARE v_usuarios_activos_hoy INT DEFAULT 0;
    DECLARE v_ingresos_hoy DECIMAL(10,2) DEFAULT 0.00;

    -- Conteo de reservas del día
    SELECT COUNT(*) INTO v_total_reservas_hoy
    FROM reserva
    WHERE fecha_reserva = CURRENT_DATE()
      AND estado_reserva IN ('confirmada', 'completada', 'pendiente');

    -- Conteo de usuarios únicos ingresados hoy
    SELECT COUNT(DISTINCT id_usuario) INTO v_usuarios_activos_hoy
    FROM control_acceso
    WHERE DATE(fecha_hora_entrada) = CURRENT_DATE()
      AND estado_acceso = 'permitido'
      AND id_usuario IS NOT NULL;

    -- Sumatoria de ingresos reales del día
    SELECT IFNULL(SUM(monto), 0.00) INTO v_ingresos_hoy
    FROM pago
    WHERE DATE(fecha_pago) = CURRENT_DATE()
      AND estado_pago = 'pagado';

    -- Retorno del reporte ejecutivo
    SELECT 
        CURRENT_DATE() AS fecha_reporte,
        v_total_reservas_hoy AS total_reservas_hoy,
        v_usuarios_activos_hoy AS usuarios_activos_hoy,
        v_ingresos_hoy AS ingresos_del_dia;
END$$

DELIMITER ;


-- ---------------------------------------------------------
-- 3. CONSULTAS EN TIEMPO REAL PARA DASHBOARD
-- ---------------------------------------------------------

-- A. Conteo directo real
SELECT 
    CONCAT('Ahora mismo hay ', COUNT(DISTINCT id_usuario), ' personas en el coworking.') AS mensaje_dashboard
FROM control_acceso
WHERE DATE(fecha_hora_entrada) = CURRENT_DATE()
  AND estado_acceso = 'permitido'
  AND fecha_hora_salida IS NULL;

-- B. Conteo simulado (Garantiza mostrar al menos 20 personas)
SELECT 
    CONCAT('Ahora mismo hay ', GREATEST(COUNT(DISTINCT id_usuario), 20), ' personas en el coworking.') AS mensaje_simulado
FROM control_acceso
WHERE DATE(fecha_hora_entrada) = CURRENT_DATE()
  AND estado_acceso = 'permitido'
  AND fecha_hora_salida IS NULL;

-- C. Reporte con métrica de nivel de aforo en pantalla
SELECT 
    GREATEST(COUNT(DISTINCT id_usuario), 20) AS personas_actuales,
    CASE 
        WHEN GREATEST(COUNT(DISTINCT id_usuario), 20) >= 30 THEN 'Aforo Alto / Instalaciones Llenas'
        WHEN GREATEST(COUNT(DISTINCT id_usuario), 20) BETWEEN 15 AND 29 THEN 'Aforo Moderado'
        ELSE 'Aforo Bajo'
    END AS estado_aforo
FROM control_acceso
WHERE DATE(fecha_hora_entrada) = CURRENT_DATE()
  AND estado_acceso = 'permitido'
  AND fecha_hora_salida IS NULL;
  
  USE coworking_db;

-- =========================================
-- CONSULTA DE DASHBOARD CON EVALUACIÓN DE AFORO
-- Hecho por Carlos Said.
-- =========================================

-- 1. Mensaje de estado con condicional de Aforo Lleno (Simulando o evaluando 30 personas)
SELECT 
    GREATEST(COUNT(DISTINCT id_usuario), 30) AS personas_actuales,
    CASE 
        WHEN GREATEST(COUNT(DISTINCT id_usuario), 30) >= 30 THEN 'Aforo Lleno'
        WHEN GREATEST(COUNT(DISTINCT id_usuario), 30) BETWEEN 15 AND 29 THEN 'Aforo Moderado'
        ELSE 'Aforo Normal'
    END AS estado_aforo,
    CONCAT(
        'Ahora mismo hay ', 
        GREATEST(COUNT(DISTINCT id_usuario), 30), 
        ' personas en el coworking. Estado: ',
        IF(GREATEST(COUNT(DISTINCT id_usuario), 30) >= 30, 'Aforo Lleno', 'Aforo Disponible')
    ) AS mensaje_dashboard
FROM control_acceso
WHERE DATE(fecha_hora_entrada) = CURRENT_DATE()
  AND estado_acceso = 'permitido'
  AND fecha_hora_salida IS NULL;

esta es la solucion funcional del examen

