
# Proyecto Turco - Gestión de Turnos de Peluquería

**Estudiante:** Maria Eduarda Acosta
**Application ID:** com.mariaeduardaacosta.turco
**Versión de Flutter usada:** 3.47.5 (canal stable)

## Descripción del Proyecto
Turco es una aplicación móvil desarrollada en Flutter para la gestión de turnos de una peluquería mixta. Está diseñada para ser utilizada por el personal de recepción y permite registrar clientes, programar turnos con estilistas, y llevar un control de la agenda diaria. 

La aplicación funciona completamente en memoria (sin servidor ni base de datos externa) y cuenta con las siguientes características principales:

- **Arquitectura MVVM:** Separación clara entre modelos de datos, lógica de negocio (ViewModels con ChangeNotifier) y vistas.
- **Navegación:** Uso de `go_router` con `StatefulShellRoute` para mantener el estado de las pestañas.
- **Gestión de Turnos:** Validación de solapes de horarios, cálculo automático de duración y precios, y control de estados (programado, completado, cancelado).
- **Formularios:** Validaciones en tiempo real y control de foco.
- **Diseño:** Interfaz adaptativa con tema global (modo claro y oscuro) siguiendo los lineamientos de Material 3.

## Cómo inicializar y ejecutar el proyecto

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/acmariaeduarda57-cell/turco_app.git
