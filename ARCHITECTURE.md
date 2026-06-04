# Arquitectura del Proyecto Petitt - Documentación Técnica

Este documento detalla la implementación de la **Arquitectura Hexagonal**, el uso de **GetX** para la gestión de estado y **SharedPreferences** para la persistencia de datos en el proyecto Petitt.

## 🏗️ Arquitectura Hexagonal (Puertos y Adaptadores)

El proyecto ha sido rediseñado siguiendo los principios de la arquitectura hexagonal para garantizar el desacoplamiento total entre la lógica de negocio y las tecnologías externas.

### 1. Capa de Dominio (`lib/domain/`)
Es el núcleo de la aplicación. No tiene dependencias de librerías externas ni de otras capas.
- **Modelos/Entidades**: Representan los objetos de negocio (e.g., `Product`, `Order`, `User`).
- **Puertos (Interfaces)**: Definen los contratos que la infraestructura debe implementar (e.g., `ProductRepository`, `LocalStorageRepository`).

### 2. Capa de Aplicación (`lib/application/`)
Contiene los **Casos de Uso**. Orquestan el flujo de datos desde y hacia el dominio.
- Ejemplo: `LoginUseCase`, `GetProductsUseCase`, `CreateOrderUseCase`.
- Se comunican con el dominio a través de los **Puertos**.

### 3. Capa de Infraestructura (`lib/infrastructure/`)
Contiene las implementaciones técnicas de los puertos definidos en el dominio.
- **Adaptadores**: Implementaciones concretas como `JsonProductAdapter` (lee archivos locales) o `SharedPrefsAdapter` (usa persistencia local).
- **Gestión de Estado (GetX)**: Aquí residen los controladores que actúan como puentes entre la UI y los casos de uso.

### 4. Capa de Presentación (`lib/infrastructure/presentation/`)
Responsable de la interfaz de usuario. En arquitectura hexagonal, se considera un adaptador primario.
- **Widgets y Screens**: Consumen los controladores de GetX para reaccionar a cambios de estado.
- **Navegación**: Gestionada de forma centralizada a través de `AppPages` y `AppRoutes`.

---

## 🚀 Gestión de Estado con GetX

GetX se utiliza de tres formas fundamentales en el proyecto:

1.  **Reactividad**: Uso de variables `.obs` y widgets `Obx()` para redibujar solo los componentes necesarios cuando el estado cambia (ej. el contador del carrito o el botón de favoritos).
2.  **Inyección de Dependencias (Bindings)**: En `initial_binding.dart`, se instancian y "pegan" los adaptadores con los casos de uso y controladores. Esto permite cambiar una base de datos o un servicio sin tocar la UI.
3.  **Navegación**: Uso de `Get.toNamed()` para una navegación desacoplada del `BuildContext`.

---

## 💾 Persistencia con SharedPreferences

La persistencia se maneja mediante el **Adaptador de Infraestructura** `SharedPrefsAdapter`, que implementa el puerto `LocalStorageRepository`.

- **Favoritos**: Se almacenan los IDs de los productos para que persistan tras reiniciar la app.
- **Sesión**: Se guarda la información básica del usuario logueado.
- **Direcciones**: Se serializan a JSON y se guardan en disco para agilizar el flujo de checkout.
- **Onboarding**: Controla si el usuario ya ha visto la introducción de la app.

---

## 🔄 Flujo de Datos (Ejemplo: Añadir a Favoritos)

1.  **UI**: El usuario pulsa el icono de corazón en `ProductCard`.
2.  **Presentación**: Se llama a `productController.toggleFavorite(product)`.
3.  **Controlador (Infraestructura)**: El controlador ejecuta el caso de uso `ToggleFavoriteUseCase`.
4.  **Caso de Uso (Aplicación)**: El caso de uso llama al método `saveFavorites()` del puerto `LocalStorageRepository`.
5.  **Adaptador (Infraestructura)**: El `SharedPrefsAdapter` ejecuta la escritura real en el almacenamiento del dispositivo.
6.  **Reacción**: El estado reactivo se actualiza y la UI cambia el color del icono instantáneamente mediante `Obx`.
