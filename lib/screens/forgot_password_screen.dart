import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';
import 'new_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final email = TextEditingController(text: 'demo@petit.com');
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    const Center(child: PetitLogo(size: 70)),
                    const SizedBox(height: 45),
                    const Text('¿Has olvidado tu contraseña?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 18),
                    TextField(
                        controller: email,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Correo electrónico',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const SizedBox(height: 8),
                    Text(
                        'Le enviaremos un mensaje para restablecer su nueva contraseña',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 24),
                    PrimaryButton(
                        text: 'Enviar',
                        onTap: () async {
                          final app = context.read<AppState>();
                          final ok = await app.auth.sendReset(email.text);
                          if (!context.mounted) return;
                          if (ok) {
                            app.lastResetEmail = email.text;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Se ha enviado un correo de verificación')));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const NewPasswordScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Correo no registrado')));
                          }
                        })
                  ]))));
}
