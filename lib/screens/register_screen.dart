import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: const Color(0xffe8f7ea),
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.camera_alt, color: Color(0xff078818))
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
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
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Número telefónico',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
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
                    final ok = await context
                        .read<AppState>()
                        .auth
                        .register(email.text, pass.text, phone.text);

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
