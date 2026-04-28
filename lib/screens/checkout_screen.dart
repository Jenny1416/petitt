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
  final name = TextEditingController(text: 'Jennifer Lopez'),
      phone = TextEditingController(text: '3001234567'),
      city = TextEditingController(text: 'Barranquilla'),
      address = TextEditingController(text: 'Calle 72 # 45 - 20');
  String payment = 'PayPal';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dirección de envío', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            _tf('Nombre', name),
            _tf('Número de teléfono', phone),
            _tf('Ciudad/Municipio', city),
            _tf('Dirección', address),
            const SizedBox(height: 24),
            const Text('Método de pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            _paymentOption('Visa', 'VISA ****2109'),
            _paymentOption('PayPal', 'PayPal ****2109'),
            _paymentOption('Contra entrega', 'Contra entrega'),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total a pagar:', style: TextStyle(fontSize: 16)),
                Text('\$${app.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Finalizar Compra',
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

  Widget _paymentOption(String value, String label) {
    return RadioListTile<String>(
      value: value,
      groupValue: payment,
      onChanged: (v) => setState(() => payment = v!),
      title: Text(label),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _tf(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          controller: c,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        ),
      );
}
