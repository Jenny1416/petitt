# PETITT - E-commerce de Mascotas Premium

PETITT es una aplicación móvil moderna desarrollada en Flutter para la comercialización de productos y accesorios para mascotas. El proyecto destaca por su diseño "Premium Organic", una arquitectura limpia y el uso de estándares profesionales de desarrollo.

## 🚀 Características Principales

- **Diseño Premium Organic**: Interfaz moderna con bordes redondeados (20px-35px), sombras suaves y una paleta de colores inspirada en la naturaleza (Verde Bosque y Ámbar).
- **Gestión de Catálogo Dinámico**: Carga de productos desde archivos JSON locales.
- **Carrito de Compras Completo**: Gestión de cantidades, cálculo de totales, ahorros y banners de envío gratis.
- **Persistencia de Favoritos**: Uso de `SharedPreferences` para mantener los productos favoritos del usuario incluso después de cerrar la app.
- **Sistema de Seguimiento de Pedidos**: Línea de tiempo interactiva para rastrear el estado de las compras.
- **Perfil de Usuario**: Gestión de información personal y direcciones de entrega.

## 🛠️ Arquitectura Técnica

El proyecto implementa el patrón de diseño **M-S-P-V (Modelo-Servicio-Provider-Vista)**, garantizando una clara separación de responsabilidades:

1.  **Modelos (`lib/models/`)**: Define la estructura de los datos (Productos, Pedidos, Usuarios).
2.  **Servicios (`lib/services/`)**: Centraliza la lógica de acceso a datos. `ProductService` gestiona el JSON y `AuthService` la simulación de autenticación.
3.  **Providers (`lib/providers/`)**: `AppState` actúa como el cerebro de la app, manejando el estado global con el paquete `Provider`.
4.  **Widgets (`lib/widgets/`)**: Librería de componentes reutilizables y consistentes.
5.  **Screens (`lib/screens/`)**: Capa de presentación que reacciona a los cambios de estado.

## 📊 Manejo de Datos

- **JSON**: Los datos del catálogo son desacoplados del código fuente, facilitando futuras integraciones con APIs reales.
- **ArrayList (Lists)**: Se utilizan estructuras de datos dinámicas para el manejo eficiente de filtros, búsquedas y gestión de inventario en tiempo real.
- **Shared Preferences**: Persistencia local para una experiencia de usuario fluida y profesional.

## 🎨 Paleta de Colores

- **Primary (Forest Green)**: `0xff123516` - Profundidad y naturaleza.
- **Accent (Amber/Gold)**: `0xffD4933E` - Elegancia y resalte de ofertas.
- **Surface**: `0xffF8F9FA` - Limpieza y legibilidad.

## 🏗️ Requisitos de Evaluación Satisfechos

- **UI (0.8)**: Diseño moderno, adaptable y uso correcto de componentes.
- **UX (0.8)**: Flujo de navegación lógico, mensajes de retroalimentación y facilidad de uso.
- **Estructura (0.8)**: Organización clara de carpetas y separación de lógica/UI.
- **Datos (1.0)**: Uso correcto de JSON y manejo avanzado de ArrayList.
- **Persistencia**: Implementación de Shared Preferences para datos locales.
