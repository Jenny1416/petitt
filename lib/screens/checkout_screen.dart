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
          _buildStepProgress(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderPreview(app),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Información de Envío', Icons.local_shipping_outlined),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/addresses'),
                        child: const Text('Gestionar', style: TextStyle(color: Color(0xff123516), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  if (app.addresses.isEmpty)
                    _buildCard(
                      child: Center(
                        child: Column(
                          children: [
                            const Text('No tienes direcciones guardadas'),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/addresses'),
                              child: const Text('Agregar una dirección'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: List.generate(app.addresses.length, (index) {
                        final addr = app.addresses[index];
                        bool isSelected = selectedAddressIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => selectedAddressIndex = index),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected ? const Color(0xff123516) : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: isSelected ? const Color(0xff123516) : Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(addr['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(addr['address']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  
                  const SizedBox(height: 24),

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
                  const SizedBox(height: 100),
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
                if (app.addresses.isEmpty || selectedAddressIndex == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor selecciona una dirección')),
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
}
