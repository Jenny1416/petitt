import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Centro de Ayuda', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff123516))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff123516), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Necesitas ayuda?', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff123516))),
            const SizedBox(height: 12),
            const Text('En PETITT queremos que tú y tu mascota tengan la mejor experiencia. Contáctanos por cualquiera de estos medios:', 
              style: TextStyle(color: Colors.black54, height: 1.5)),
            const SizedBox(height: 32),
            
            _buildContactInfo(Icons.email_outlined, 'Correo electrónico', 'soporte@petit.com'),
            _buildContactInfo(Icons.phone_outlined, 'Línea de atención', '+57 300 123 4567'),
            _buildContactInfo(Icons.access_time, 'Horario de atención', 'Lunes a Viernes: 8:00 AM - 6:00 PM'),

            const SizedBox(height: 40),
            const Text('Preguntas Frecuentes', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff123516))),
            const SizedBox(height: 16),
            
            _buildFaqItem('¿Cuánto tarda mi pedido?', 'El tiempo de entrega en Barranquilla es de 24 horas. Para el resto del país, entre 2 y 5 días hábiles.'),
            _buildFaqItem('¿Cómo realizo una devolución?', 'Puedes solicitar una devolución si el producto está sellado y en perfecto estado dentro de los primeros 5 días.'),
            _buildFaqItem('¿Tienen tiendas físicas?', 'Actualmente somos una tienda 100% digital, lo que nos permite ofrecerte mejores precios.'),
            _buildFaqItem('¿Los envíos tienen costo?', '¡Sí! Pero si tu compra supera los \$50,000, el envío es totalmente GRATIS.'),

            const SizedBox(height: 40),
            Center(
              child: Text('PETITT v1.0.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff123516).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xff123516), size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        iconColor: const Color(0xff123516),
        collapsedIconColor: Colors.grey,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(answer, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
