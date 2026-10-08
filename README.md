# examen-Mysql2
Documentación Técnica Extendida: Dashboard de Recepción (coworking_db)
Estudiante / Desarrollador: Carlos Said

Asignatura / Módulo: Gestión de Bases de Datos Relacionales (MySQL)

Plataforma de Evaluación: Campuslands

Entregables del Proyecto: Repositorio público/privado en GitHub compuesto por el script SQL de producción con comentarios lógicos integrados y la documentación ejecutiva README.md.

1. Contexto Operativo y Objetivos del Examen
El propósito fundamental de este examen práctico es la concepción, diseño e implementación de una solución de persistencia de datos en tiempo real adaptada a la infraestructura operativa de la recepción de un edificio de Coworking.

En el flujo diario de trabajo, el personal de recepción requiere una herramienta ágil e intuitiva que centralice la información dispersa en el modelo relacional sin afectar el rendimiento de la base de datos principal. La solución desarrollada resuelve esta necesidad mediante tres componentes estratégicos:

Monitoreo de Infraestructura Física (VW_EstadoEspacios): Proporciona visibilidad en tiempo real sobre el estado operativo de las salas, oficinas y escritorios, sincronizando la disponibilidad actual con el cronograma de reservas futuras.

Consolidación de Métricas Operativas (sp_GenerarReporteDiario): Automatiza el cálculo de indicadores clave de rendimiento (KPIs) diarios, combinando la concurrencia de usuarios, la actividad transaccional y la recaudación monetaria de la jornada.

Control de Ocupación e Indicador en Pantalla (Consulta en Tiempo Real): Ofrece un semáforo visual sobre la densidad de personas dentro de la sede para optimizar la seguridad, el flujo de paso en torniquetes y la atención al cliente.

2. Explicación Detallada de la Lógica del Script SQL
A. Vista de Disponibilidad Física (VW_EstadoEspacios)
Mapeo Dinámico de Estados: La vista realiza una proyección sobre la entidad espacio, aplicando una cláusula condicional CASE para estandarizar los estados del sistema. Transforma las banderas internas de la base de datos en categorías comprensibles para el usuario final: 'Ocupado', 'Mantenimiento' o 'Libre'.

Proyección de Próxima Reserva: Incorpora una subconsulta escalar que examina la tabla reserva buscando aquellos registros cuya fecha y hora sean iguales o posteriores al instante de la consulta (CURRENT_DATE() y CURRENT_TIME()). Mediante la función de agregación MIN(), identifica con precisión la reserva confirmada o pendiente más cercana, permitiendo a recepción anticipar la entrega de llaves o la preparación del espacio.

B. Procedimiento Almacenado de Balance Operativo (sp_GenerarReporteDiario)
Conteo de Reservas del Día: Realiza una lectura de la entidad reserva filtrando por la fecha actual (CURRENT_DATE()) e incluyendo únicamente estados operativamente válidos ('confirmada', 'completada' o 'pendiente').

Concurrencia de Usuarios Activos: Evalúa los registros de la tabla control_acceso. Utiliza la función de agregación COUNT(DISTINCT id_usuario) filtrando por accesos con estado 'permitido' en la fecha actual, lo que garantiza contar individuos únicos sin duplicar asistencias por múltiples entradas durante la misma jornada.

Consolidación Financiera Diaria: Realiza la sumatoria acumulada (SUM) de la entidad pago para las transacciones procesadas con estado 'pagado' dentro de la fecha actual. Utiliza la función IFNULL() para prevenir retornos nulos (NULL) en días donde aún no se hayan registrado ingresos, garantizando un valor monetario por defecto de 0.00.

C. Consulta de Ocupación en Tiempo Real (Pantalla de Control)
Auditoría de Presencia Física: Filtra la tabla control_acceso considerando los ingresos autorizados del día donde el atributo fecha_hora_salida permanezca nulo (IS NULL), lo cual representa a los usuarios que cruzaron el acceso y continúan dentro de las instalaciones.

Evaluación de Nivel de Ocupación: Incorpora una lógica de clasificación para categorizar la capacidad utilizada. Si la cantidad de personas presentes alcanza o supera el umbral límite (30 personas), la consulta categoriza el estado como 'Coworking Lleno'; de lo contrario, determina estados intermedios de disponibilidad ('Coworking Moderado' o 'Coworking Normal').

Salida Estandarizada para Interfaz: Retorna la cadena de texto exacta requerida por el sistema de recepción: "Ahora mismo hay X personas en el coworking. Estado: Coworking Lleno", simplificando la integración con cualquier panel web o aplicación de escritorio.

3. Protocolo de Entrega y Sustentación en Campuslands
Estructuración en GitHub: El repositorio debe contener en su raíz el archivo README.md minuciosamente redactado y el script ejecutable .sql estructurado bajo estándares de sintaxis limpia, uso de delimitadores (DELIMITER), gestión de transacciones y comentarios descriptivos.

Publicación y Registro: La URL del repositorio debe ser vinculada en el espacio correspondiente dentro de la plataforma Campuslands antes de la hora límite fijada (5:00 PM). Cualquier modificación posterior al horario establecido invalidará la versión entregada.

Defensa Teórica del Script: El estudiante debe estar preparado para sustentar técnicamente las decisiones de diseño adoptadas, demostrando dominio en:

Optimización de consultas mediante filtros temporales dinámicos (CURRENT_DATE(), CURRENT_TIME()).

Uso eficiente de JOINs, subconsultas escalares y agregaciones (COUNT(DISTINCT), SUM, MIN).

Creación y encapsulamiento de lógica mediante Vistas (VIEW) y Procedimientos Almacenados (STORED PROCEDURE).
