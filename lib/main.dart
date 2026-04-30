import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => AppState()..init(), child: const PetitApp()));
}

class PetitApp extends StatelessWidget {
  const PetitApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PETIT',
      theme: ThemeData(
        useMaterial3: true,
        // Usamos una tipografía más moderna y limpia
        fontFamily: 'SF Pro Display', 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff123516),
          primary: const Color(0xff123516),
          secondary: const Color(0xffD4933E), // Color ámbar/dorado de la imagen
          surface: Colors.white,
          background: const Color(0xffF8F9FA), // Fondo ligeramente grisáceo
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
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
