import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';

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
            fontFamily: 'Arial',
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff078818)),
            scaffoldBackgroundColor: Colors.white),
        home: const SplashScreen());
  }
}
