import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController p1 = TextEditingController(), p2 = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Center(child: PetitLogo(size: 70)),
                    const SizedBox(height: 50),
                    const Text('Crear nueva contraseña',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                        controller: p1,
                        obscureText: true,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Nueva contraseña',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const SizedBox(height: 12),
                    TextField(
                        controller: p2,
                        obscureText: true,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Confirmar nueva contraseña',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const SizedBox(height: 24),
                    PrimaryButton(
                        text: 'Actualizar Contraseña',
                        onTap: () async {
                          if (p1.text != p2.text || p1.text.length < 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Las contraseñas no coinciden o son muy cortas')));
                            return;
                          }
                          final app = context.read<AppState>();
                          await app.auth.updatePassword(
                              app.lastResetEmail ?? 'demo@petit.com', p1.text);
                          if (!context.mounted) return;
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                      icon: const Icon(Icons.verified,
                                          color: Color(0xff078818), size: 60),
                                      content: const Text(
                                          'Tu contraseña se ha actualizado con éxito',
                                          textAlign: TextAlign.center),
                                      actions: [
                                        PrimaryButton(
                                            text: 'Continuar',
                                            onTap: () =>
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const LoginScreen()),
                                                    (_) => false))
                                      ]));
                        })
                  ]))));
}
