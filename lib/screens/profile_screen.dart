import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
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
    app.updateProfile(_nameController.text, _phoneController.text);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Información Personal', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff123516))),
                      TextButton.icon(
                        onPressed: () => setState(() => _isEditing = !_isEditing),
                        icon: Icon(_isEditing ? Icons.close : Icons.edit, size: 18),
                        label: Text(_isEditing ? 'Cancelar' : 'Editar'),
                        style: TextButton.styleFrom(foregroundColor: _isEditing ? Colors.red : const Color(0xff123516)),
                      ),
                    ],
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
                  const Text('Mi Actividad', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff123516))),
                  const SizedBox(height: 16),
                  
                  _buildMenuTile(Icons.shopping_bag_outlined, 'Mis Pedidos', 'Ver historial y estado', () => app.setHomeTabIndex(3)),
                  _buildMenuTile(Icons.favorite_outline, 'Mis Favoritos', 'Productos que te encantan', () => app.setHomeTabIndex(1)),
                  _buildMenuTile(Icons.location_on_outlined, 'Direcciones', 'Gestionar lugares de entrega', () => Navigator.pushNamed(context, '/addresses')),
                  _buildMenuTile(Icons.headset_mic_outlined, 'Soporte', 'Ayuda y Centro de atención', () => Navigator.pushNamed(context, '/support')),
                  
                  const SizedBox(height: 24),
                  _buildMenuTile(Icons.logout, 'Cerrar Sesión', 'Salir de tu cuenta', () {
                    // Aquí iría la lógica de logout real
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  }, isDanger: true),
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

  Widget _buildMenuTile(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDanger = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDanger ? Colors.red.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: isDanger ? Colors.red : const Color(0xff123516), size: 22),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDanger ? Colors.red : Colors.black87)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
