import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(text: 'demo@petit.com'),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Correo electrónico',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pass,
                  obscureText: ob,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Contraseña',
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      icon: Icon(ob ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => ob = !ob),
                    ),
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
                          final ok = await context
                              .read<AppState>()
                              .auth
                              .login(email.text, pass.text);
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
