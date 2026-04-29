import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController(text: 'demo@petit.com'),
      pass = TextEditingController(text: '123456');
  bool loading = false, ob = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45),
                const Center(child: PetitLogo(size: 70)),
                const SizedBox(height: 40),
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xff123516)),
                ),
                const SizedBox(height: 8),
                Text(
                  '¡Qué bueno verte de nuevo!',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Correo electrónico',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: pass,
                  obscureText: ob,
                  hintText: 'Contraseña',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(ob ? Icons.visibility_off : Icons.visibility, color: const Color(0xff123516)),
                    onPressed: () => setState(() => ob = !ob),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: loading ? 'Validando...' : 'Ingresar',
                  onTap: loading
                      ? null
                      : () async {
                          setState(() => loading = true);
                          final app = context.read<AppState>();
                          final ok = await app.login(email.text, pass.text);
                          setState(() => loading = false);

                          if (!context.mounted) return;

                          if (ok) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.home, (_) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Correo o contraseña incorrectos'),
                              ),
                            );
                          }
                        },
                ),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text('Crear cuenta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
