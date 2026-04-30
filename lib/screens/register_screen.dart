import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController phone = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Comprime la imagen para no ocupar mucho espacio
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
                  'Crear una Cuenta',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xff123516)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Únete a la familia Smart Pet',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xffD4933E), width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xffe8f7ea),
                            backgroundImage: _image != null ? FileImage(_image!) : null,
                            child: _image == null
                                ? const Icon(Icons.person_outline, size: 40, color: Color(0xff123516))
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Color(0xffD4933E), shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  obscureText: true,
                  hintText: 'Contraseña',
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  hintText: 'Número telefónico',
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Hecho',
                  onTap: () async {
                    if (email.text.isEmpty || pass.text.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Completa los datos. La contraseña debe tener mínimo 4 caracteres.'),
                        ),
                      );
                      return;
                    }
                    
                    // Aquí podrías guardar la imagen (_image) en tu AppState o base de datos
                    final app = context.read<AppState>();
                    final ok = await app.register(email.text, pass.text, phone.text);

                    if (!context.mounted) return;

                    if (ok) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.onboarding1, (_) => false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('El correo ya existe')),
                      );
                    }
                  },
                ),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
