import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfile(BuildContext context, AppState app) {
    final nameController = TextEditingController(text: app.auth.currentUser?.name);
    final phoneController = TextEditingController(text: app.auth.currentUser?.phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Editar Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(height: 8),
            const Text('Actualiza tu información personal para tus pedidos.', style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                hintText: 'Ej. Jennifer Lopez',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                hintText: '300 123 4567',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff123516),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  app.updateUserInfo(
                    name: nameController.text,
                    phone: phoneController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil actualizado correctamente'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xff078818),
                    ),
                  );
                },
                child: const Text('Guardar Cambios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.auth.currentUser;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // Header con Avatar y Nombre
        Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xff078818).withOpacity(0.2), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xff123516),
                      child: Icon(Icons.person, color: Colors.white, size: 55),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Color(0xff078818), shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'Usuario PETIT',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: -0.5),
              ),
              Text(
                user?.email ?? 'demo@petit.com',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        _buildSectionTitle('Mi Cuenta'),
        _buildListTile(
          icon: Icons.person_outline,
          title: 'Información Personal',
          subtitle: 'Nombre, teléfono y correo electrónico',
          onTap: () => _showEditProfile(context, app),
        ),
        _buildListTile(
          icon: Icons.location_on_outlined,
          title: 'Mis Direcciones',
          subtitle: 'Gestiona tus lugares de entrega',
          onTap: () {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gestión de direcciones (Próximamente)'), behavior: SnackBarBehavior.floating),
            );
          },
        ),
        _buildListTile(
          icon: Icons.payment_outlined,
          title: 'Métodos de Pago',
          subtitle: 'Tarjetas y opciones de pago guardadas',
          onTap: () {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Métodos de pago (Próximamente)'), behavior: SnackBarBehavior.floating),
            );
          },
        ),

        const SizedBox(height: 24),
        _buildSectionTitle('Soporte y Legal'),
        _buildListTile(
          icon: Icons.help_outline,
          title: 'Centro de Ayuda',
          subtitle: 'Preguntas frecuentes y soporte técnico',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'PETIT Support',
              applicationVersion: '1.0.0',
              children: [
                const Text('¿Tienes problemas con tu pedido?'),
                const SizedBox(height: 10),
                const Text('Escríbenos a:', style: TextStyle(fontSize: 12)),
                const Text('soporte@petit.com.co', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff078818))),
              ],
            );
          },
        ),
        _buildListTile(
          icon: Icons.description_outlined,
          title: 'Términos y Privacidad',
          subtitle: 'Políticas de uso y manejo de datos',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Políticas PETIT', style: TextStyle(fontWeight: FontWeight.bold)),
                content: const SingleChildScrollView(
                  child: Text('En PETIT nos tomamos en serio tu privacidad. Tus datos están protegidos y solo se usan para mejorar tu experiencia de compra y asegurar las entregas de tus mascotas.'),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido')),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.red),
            onTap: () {
              app.logout();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
          ),
        ),
        const SizedBox(height: 40),
        const Center(
          child: Text('PETIT App v1.0.0', style: TextStyle(color: Colors.grey, fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xff078818).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xff078818), size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: -0.2)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }
}
