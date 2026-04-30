import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().auth.currentUser;
    _nameController = TextEditingController(text: user?.name);
    _phoneController = TextEditingController(text: user?.phone);
    _emailController = TextEditingController(text: user?.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final app = context.read<AppState>();
    app.updateUserInfo(_nameController.text, _phoneController.text);
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil actualizado correctamente'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con degradado
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff123516), Color(0xff1e5a25)],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 60, color: Color(0xff123516)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Usuario PETITT',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    user?.email ?? 'correo@ejemplo.com',
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: 'Información Personal',
                    actionText: _isEditing ? 'Cancelar' : 'Editar',
                    onActionTap: () {
                      if (_isEditing) {
                        // Reset controllers to current user state
                        final user = context.read<AppState>().auth.currentUser;
                        _nameController.text = user?.name ?? '';
                        _phoneController.text = user?.phone ?? '';
                      }
                      setState(() => _isEditing = !_isEditing);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoCard(),
                  
                  if (_isEditing) ...[
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'Guardar Cambios',
                      onTap: _saveProfile,
                    ),
                  ],

                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Mi Actividad'),
                  const SizedBox(height: 16),
                  
                  ProfileMenuTile(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Mis Pedidos',
                    subtitle: 'Ver historial y estado de tus compras',
                    onTap: () => app.setHomeTabIndex(3),
                  ),
                  ProfileMenuTile(
                    icon: Icons.favorite_outline,
                    title: 'Mis Favoritos',
                    subtitle: 'Productos que te han encantado',
                    onTap: () => app.setHomeTabIndex(1),
                  ),
                  ProfileMenuTile(
                    icon: Icons.location_on_outlined,
                    title: 'Direcciones',
                    subtitle: 'Gestionar tus lugares de entrega',
                    onTap: () => Navigator.pushNamed(context, '/addresses'),
                  ),
                  ProfileMenuTile(
                    icon: Icons.headset_mic_outlined,
                    title: 'Soporte',
                    subtitle: 'Ayuda y centro de atención al cliente',
                    onTap: () => Navigator.pushNamed(context, '/support'),
                  ),
                  
                  const SizedBox(height: 12),
                  ProfileMenuTile(
                    icon: Icons.logout,
                    title: 'Cerrar Sesión',
                    subtitle: 'Finalizar sesión en este dispositivo',
                    onTap: () {
                      app.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    isDanger: true,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _buildEditableField('Nombre', _nameController, Icons.person_outline, _isEditing),
          const Divider(height: 30),
          _buildEditableField('Teléfono', _phoneController, Icons.phone_android_outlined, _isEditing),
          const Divider(height: 30),
          _buildEditableField('Email', _emailController, Icons.email_outlined, false), // Email no editable por ahora
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, IconData icon, bool enabled) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xff123516), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              if (enabled)
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )
              else
                Text(controller.text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }

}
