import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().auth.currentUser;
    return ListView(padding: const EdgeInsets.all(16), children: [
      const CircleAvatar(
          radius: 45,
          backgroundColor: Color(0xff113d18),
          child: Icon(Icons.person, color: Colors.white, size: 52)),
      const SizedBox(height: 12),
      Center(
          child: Text(user?.name ?? 'Usuario PETIT',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
      Center(child: Text(user?.email ?? 'demo@petit.com')),
      const SizedBox(height: 25),
      const ListTile(
          leading: Icon(Icons.person_outline),
          title: Text('Gestión de cuenta'),
          subtitle: Text('Datos personales, correo y contraseña')),
      const ListTile(
          leading: Icon(Icons.favorite_border),
          title: Text('Preferencias'),
          subtitle: Text('Productos guardados e historial')),
      const ListTile(
          leading: Icon(Icons.support_agent),
          title: Text('Soporte'),
          subtitle: Text('Ayuda y preguntas frecuentes')),
      const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('PETIT'),
          subtitle: Text('E-commerce especializado en pet care en Colombia'))
    ]);
  }
}
