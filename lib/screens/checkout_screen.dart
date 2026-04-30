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
  int? selectedAddressIndex = 0;
  String payment = 'PayPal';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        title: const Text('Finalizar pedido'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Barra de progreso mejorada
          _buildStepProgress(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen rápido
                  _buildSectionHeader('Resumen de pedido', null),
                  _buildOrderPreview(app),
                  
                  const SizedBox(height: 32),

                  // Envío
                  _buildSectionHeader('Información de envío', () => Navigator.pushNamed(context, '/addresses')),
                  const SizedBox(height: 12),
                  
                  if (app.addresses.isEmpty)
                    _buildEmptyState('No tienes direcciones guardadas', Icons.location_off_outlined, '/addresses')
                  else
                    ...List.generate(app.addresses.length, (index) {
                      final addr = app.addresses[index];
                      bool isSelected = selectedAddressIndex == index;
                      return _buildAddressOption(addr, isSelected, index);
                    }),
                  
                  const SizedBox(height: 32),

                  // Pago
                  _buildSectionHeader('Método de pago', null),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _paymentOption('Visa', 'Tarjeta Visa •••• 2109', Icons.credit_card_rounded),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Divider(height: 1, color: Colors.grey.shade50)),
                        _paymentOption('PayPal', 'Cuenta PayPal', Icons.account_balance_wallet_rounded),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Divider(height: 1, color: Colors.grey.shade50)),
                        _paymentOption('Contra entrega', 'Efectivo al recibir', Icons.handshake_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 140),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepItem(Icons.shopping_cart_rounded, 'Carrito', true),
          _stepConnector(true),
          _stepItem(Icons.local_shipping_rounded, 'Checkout', true),
          _stepConnector(false),
          _stepItem(Icons.check_circle_rounded, 'Confirmar', false),
        ],
      ),
    );
  }

  Widget _stepItem(IconData icon, String label, bool active) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? const Color(0xff123516) : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: active ? Colors.white : Colors.grey.shade400),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 10, color: active ? const Color(0xff123516) : Colors.grey.shade400, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _stepConnector(bool active) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0).copyWith(bottom: 18),
      decoration: BoxDecoration(
        color: active ? const Color(0xff123516) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onAction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff123516))),
          if (onAction != null)
            GestureDetector(
              onTap: onAction,
              child: const Text('Gestionar', style: TextStyle(color: Color(0xffD4933E), fontWeight: FontWeight.bold, fontSize: 14)),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressOption(Map<String, String> addr, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedAddressIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xff123516) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xff123516).withOpacity(0.05) : const Color(0xffF8F9FA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? Icons.location_on_rounded : Icons.location_on_outlined,
                color: isSelected ? const Color(0xff123516) : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(addr['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xff123516))),
                  const SizedBox(height: 2),
                  Text(addr['address']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xff123516), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderPreview(AppState app) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 80,
            child: Stack(
              children: List.generate(
                app.cart.length > 3 ? 3 : app.cart.length,
                (i) => Positioned(
                  left: i * 15.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(app.cart[i].product.image),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${app.cart.length} productos en total',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xff123516)),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text, IconData icon, String route) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(color: Colors.grey)),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, route),
            child: const Text('Agregar ahora', style: TextStyle(color: Color(0xffD4933E), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, AppState app) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total a pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)),
                Text('\$${app.total.toStringAsFixed(0)}', 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xff123516))
                ),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Confirmar orden',
              onTap: () {
                if (app.addresses.isEmpty || selectedAddressIndex == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor selecciona una dirección'), behavior: SnackBarBehavior.floating),
                  );
                  return;
                }
                final selectedAddr = app.addresses[selectedAddressIndex!];
                final order = app.createOrder(selectedAddr['address']!, payment);
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
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xff123516).withOpacity(0.05) : const Color(0xffF8F9FA),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? const Color(0xff123516) : Colors.grey, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, 
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                  color: isSelected ? const Color(0xff123516) : Colors.black87
                )
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? const Color(0xff123516) : Colors.grey.shade300,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
