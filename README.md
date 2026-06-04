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

El proyecto implementa una **Arquitectura Hexagonal (Puertos y Adaptadores)** junto con **GetX**, garantizando un desacoplamiento total entre la lógica de negocio y las tecnologías externas:

1.  **Dominio (`lib/domain/`)**: El núcleo puro de la aplicación. Contiene las entidades de negocio y las definiciones de interfaces (**Puertos**).
2.  **Aplicación (`lib/application/`)**: Contiene los **Casos de Uso** que orquestan la lógica de negocio, comunicándose con el dominio.
3.  **Infraestructura (`lib/infrastructure/`)**: Contiene las implementaciones técnicas (**Adaptadores**), la gestión de estado reactivo con GetX y la persistencia de datos.
4.  **Presentación (`lib/presentation/`)**: Interfaz de usuario reactiva, widgets atómicos y gestión de rutas centralizada.

Para un desglose detallado de la arquitectura, consulta el archivo [ARCHITECTURE.md](./ARCHITECTURE.md).

## 📊 Manejo de Datos y Estado

- **GetX**: Gestión de estado ultra-reactiva y sistema de inyección de dependencias (Bindings) para desacoplar componentes.
- **Puertos de Persistencia**: Implementación de repositorios locales que abstraen el uso de SharedPreferences.
- **Flutter 3.x Ready**: Migración completa a los últimos estándares del SDK (como el uso de `.withValues()` para opacidad).
- **JSON Local**: Catálogo de productos desacoplado del código fuente para simular integraciones con APIs reales.

## 🎨 Paleta de Colores

- **Primary (Forest Green)**: `0xff123516` - Profundidad y naturaleza.
- **Accent (Amber/Gold)**: `0xffD4933E` - Elegancia y resalte de ofertas.
- **Surface**: `0xffF8F9FA` - Limpieza y legibilidad.


