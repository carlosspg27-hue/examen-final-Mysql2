# examen-Mysql2
Documentación del Proyecto: Dashboard para Recepción (coworking_db)
Estudiante / Desarrollador: Carlos Said

Asignatura / Módulo: Base de Datos MySQL

Plataforma de Entrega: Campuslands

Entregables: Repositorio en GitHub (Script SQL con comentarios de lógica y archivo README.md estructurado).

1. Contexto y Objetivos del Examen
El objetivo principal de este examen es diseñar e implementar componentes en tiempo real para el módulo operativo de recepción de un espacio de Coworking. El dashboard busca solucionar las necesidades operativas diarias de la recepcionista mediante la consolidación de métricas de ocupación, reporte de ingresos en vivo y gestión visual del estado de cada espacio.

Tareas y Requerimientos Cumplidos:
Vista VW_EstadoEspacios: Visualización clara del identificador del espacio, su capacidad, su estado dinámico (Libre, Ocupado o Mantenimiento) y la fecha y hora exacta de la próxima reserva programada.

Procedimiento Almacenado sp_GenerarReporteDiario: Consolidación automática del balance diario, calculando el total de reservas activas del día, la cantidad de usuarios únicos dentro de las instalaciones e ingresos recaudados.

Consulta de Ocupación en Tiempo Real: Indicador simulado para la pantalla principal que emite un mensaje estructurado evaluando el total de usuarios presentes y el estado general del establecimiento (Coworking Lleno, Coworking Moderado o Coworking Normal).

2. Explicación de la Lógica del Script
A. Vista VW_EstadoEspacios
Mapeo de Disponibilidad: Utiliza una estructura condicional para traducir el estado del espacio. Si el estado interno registra ocupado o mantenimiento, la vista devuelve la etiqueta correspondiente; en cualquier otro caso, devuelve Libre.

Cálculo de Próxima Reserva: Mediante una subconsulta escalar con la función de agregación para fechas mínimas, la vista busca el horario de la reserva confirmada o pendiente más cercana en el tiempo (para el día actual o días posteriores).

B. Procedimiento Almacenado sp_GenerarReporteDiario
Total de Reservas: Realiza un conteo dinámico de todas las reservas registradas para la fecha actual en estados pendiente, confirmada o completada.

Usuarios Activos: Calcula la cantidad de usuarios únicos que han registrado un acceso con estado permitido en la fecha actual, descartando registros nulos o no autorizados.

Ingresos del Día: Realiza la sumatoria de los montos registrados en la tabla de pagos para la fecha actual, filtrando exclusivamente los pagos en estado pagado y manejando valores nulos con un valor por defecto en cero.

C. Consulta en Tiempo Real (Indicador de Ocupación)
Filtrado de Usuarios Presentes: Filtra los registros de acceso del día actual que tienen estado permitido y cuya fecha y hora de salida se encuentra nula, indicando que la persona aún está en las instalaciones.

Evaluación de Estado: Clasifica el número de ocupantes en pantalla. Si la cantidad alcanza o supera las 30 personas, emite la etiqueta Coworking Lleno.

Formato del Mensaje: Imprime la cadena de texto exacta requerida para la interfaz del recepcionista: "Ahora mismo hay X personas en el coworking. Estado: Coworking Lleno".

4. Pasos para la Presentación y Sustentación en Campuslands
Subida al Repositorio: Asegurarse de que el script SQL contenga todos los comentarios explicativos y que el archivo README.md esté guardado en la raíz del proyecto.

Entrega de Enlace: Copiar la URL pública de GitHub y pegarla en el módulo de entregas de la plataforma Campuslands.

Límite de Tiempo: La entrega y última modificación del repositorio debe quedar registrada estrictamente antes de las 5:00 PM del día de hoy.

Sustentación: Dominar la explicación de cada componente SQL (subconsultas escalares, condicionales CASE, funciones de agregación y filtros por fechas dinámicas) para responder las preguntas teóricas del evaluador.
