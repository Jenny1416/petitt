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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Dirección de envío',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              _tf('Nombre', name),
              _tf('Número de teléfono', phone),
              _tf('Ciudad/Municipio', city),
              _tf('Dirección', address),
              const SizedBox(height: 14),
              const Text('Método de pago',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              RadioListTile<String>(
                  value: 'Visa',
                  groupValue: payment,
                  onChanged: (v) => setState(() => payment = v!),
                  title: const Text('VISA ****2109')),
              RadioListTile<String>(
                  value: 'PayPal',
                  groupValue: payment,
                  onChanged: (v) => setState(() => payment = v!),
                  title: const Text('PayPal ****2109')),
              RadioListTile<String>(
                  value: 'Contra entrega',
                  groupValue: payment,
                  onChanged: (v) => setState(() => payment = v!),
                  title: const Text('Contra entrega')),
              const Divider(),
              Text('Total a pagar: \$${app.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 14),
              PrimaryButton(
                  text: 'Continuar',
                  onTap: () {
                    final order = app.createOrder(
                        '${address.text}, ${city.text}', payment);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OrderSuccessScreen(order: order)),
                        (r) => r.isFirst);
                  })
            ])));
  }

  Widget _tf(String label, TextEditingController c) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
          controller: c,
          decoration: InputDecoration(
              labelText: label, border: const OutlineInputBorder())));
}
