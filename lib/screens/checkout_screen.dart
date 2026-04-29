import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/primary_button.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController name = TextEditingController(text: 'Jennifer Lopez'),
      phone = TextEditingController(text: '3001234567'),
      city = TextEditingController(text: 'Barranquilla'),
      address = TextEditingController(text: 'Calle 72 # 45 - 20');
  
  String payment = 'PayPal';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Finalizar Pedido', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff123516))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff123516), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Barra de progreso visual
          _buildStepProgress(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen de productos rápido
                  _buildOrderPreview(app),
                  const SizedBox(height: 24),

                  // Sección: Datos de Envío
                  _buildSectionTitle('Información de Envío', Icons.local_shipping_outlined),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Column(
                      children: [
                        _tf('Nombre completo', name, Icons.person_outline),
                        _tf('Teléfono de contacto', phone, Icons.phone_android_outlined),
                        _tf('Ciudad / Municipio', city, Icons.location_city_outlined),
                        _tf('Dirección exacta', address, Icons.home_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sección: Método de Pago
                  _buildSectionTitle('Método de Pago', Icons.account_balance_wallet_outlined),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Column(
                      children: [
                        _paymentOption('Visa', 'Tarjeta Visa •••• 2109', Icons.credit_card),
                        const Divider(height: 1),
                        _paymentOption('PayPal', 'Cuenta PayPal', Icons.payment),
                        const Divider(height: 1),
                        _paymentOption('Contra entrega', 'Pagar en efectivo al recibir', Icons.handshake_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Espacio para el botón inferior
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(context, app),
    );
  }

  Widget _buildStepProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepIcon(Icons.shopping_cart, 'Carrito', true),
          _stepDivider(true),
          _stepIcon(Icons.description, 'Checkout', true),
          _stepDivider(false),
          _stepIcon(Icons.check_circle, 'Confirmación', false),
        ],
      ),
    );
  }

  Widget _stepIcon(IconData icon, String label, bool active) {
    return Column(
      children: [
        Icon(icon, size: 20, color: active ? const Color(0xff123516) : Colors.grey.shade300),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: active ? const Color(0xff123516) : Colors.grey.shade400, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _stepDivider(bool active) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
      color: active ? const Color(0xff123516) : Colors.grey.shade200,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xff123516)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff123516))),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildOrderPreview(AppState app) {
    return _buildCard(
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 100,
            child: Stack(
              children: List.generate(
                app.cart.length > 3 ? 3 : app.cart.length,
                (i) => Positioned(
                  left: i * 20.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        app.cart[i].product.image,
                        width: 36, height: 36, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${app.cart.length} productos',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, AppState app) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total a pagar', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('\$${app.total.toStringAsFixed(0)}', 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff123516))
                ),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Confirmar y Pagar',
              onTap: () {
                final order = app.createOrder('${address.text}, ${city.text}', payment);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: order)),
                  (r) => r.isFirst,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(String value, String label, IconData icon) {
    bool isSelected = payment == value;
    return InkWell(
      onTap: () => setState(() => payment = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xff123516).withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? const Color(0xff123516) : Colors.grey, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, 
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xff123516) : Colors.black87
                )
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xff123516), size: 20)
            else
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tf(String label, TextEditingController c, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextField(
          controller: c,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 20, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff123516), width: 1),
            ),
            labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
      );
}
