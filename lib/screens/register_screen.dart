import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController(),
      pass = TextEditingController(),
      phone = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: PetitLogo(size: 78)),
                    const SizedBox(height: 24),
                    const Text('Crear una Cuenta',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 18),
                    const Center(
                        child: CircleAvatar(
                            radius: 34,
                            backgroundColor: Color(0xffe8f7ea),
                            child: Icon(Icons.camera_alt,
                                color: Color(0xff078818)))),
                    const SizedBox(height: 18),
                    TextField(
                        controller: email,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Correo electrónico',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const SizedBox(height: 12),
                    TextField(
                        controller: pass,
                        obscureText: true,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Contraseña',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const SizedBox(height: 12),
                    TextField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Número telefónico',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const Spacer(),
                    PrimaryButton(
                        text: 'Hecho',
                        onTap: () async {
                          if (email.text.isEmpty || pass.text.length < 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Completa los datos. La contraseña debe tener mínimo 4 caracteres.')));
                            return;
                          }
                          final ok = await context
                              .read<AppState>()
                              .auth
                              .register(email.text, pass.text, phone.text);
                          if (!context.mounted) return;
                          if (ok) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()),
                                (_) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('El correo ya existe')));
                          }
                        }),
                    Center(
                        child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar')))
                  ]))));
}
