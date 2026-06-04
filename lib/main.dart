import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'infrastructure/state/bindings/initial_binding.dart';
import 'infrastructure/presentation/routes/app_pages.dart';

/// PUNTO DE ENTRADA DE LA APLICACIÓN
/// Aquí se inicializan los servicios globales y se configura el framework GetX.
void main() async {
  // Asegura que los bindings de Flutter estén listos antes de usar SharedPreferences u otros plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Supabase
  await Supabase.initialize(
    url: 'https://ljdpunxhzbuoarnzeowa.supabase.co',
    anonKey: 'sb_publishable_xKVU3rQx3lPQn6InqfgJYA_ByMCppt9',
  );
  
  runApp(const PetitApp());
}

class PetitApp extends StatelessWidget {
  const PetitApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Uso de GetMaterialApp para habilitar la gestión de estado y navegación de GetX.
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PETIT',
      
      // ARQUITECTURA: El binding inicial inyecta los repositorios y controladores globales
      // permitiendo el desacoplamiento entre capas desde el arranque.
      initialBinding: InitialBinding(),
      
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display', 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff123516),
          primary: const Color(0xff123516),
          secondary: const Color(0xffD4933E),
          surface: Colors.white,
          surfaceContainerHighest: const Color(0xffF8F9FA),
        ),
        scaffoldBackgroundColor: const Color(0xffF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xff123516)),
          titleTextStyle: TextStyle(
            color: Color(0xff123516),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff123516),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xff123516), width: 1),
          ),
        ),
      ),
      
      // GESTIÓN DE NAVEGACIÓN: Definición centralizada de rutas.
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
