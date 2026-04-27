import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/primary_button.dart';

class ReviewsScreen extends StatefulWidget {
  final Product product;
  const ReviewsScreen({super.key, required this.product});
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final title = TextEditingController(), body = TextEditingController();
  final reviews = <Map<String, String>>[
    {
      'name': 'Veronika',
      'text': 'Producto de buena calidad. Llegó a tiempo y en buen estado.'
    },
    {
      'name': 'Carlos',
      'text': 'La compra fue sencilla y el producto cumplió con la descripción.'
    }
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Calificación')),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...reviews.map((r) => ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(r['name']!),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('★★★★★',
                          style: TextStyle(color: Colors.amber)),
                      Text(r['text']!)
                    ]))),
            const Divider(),
            const Text('Escribe una reseña',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ListTile(
                leading: Image.network(widget.product.image,
                    width: 55,
                    errorBuilder: (_, __, ___) => const Icon(Icons.pets)),
                title: Text(widget.product.name),
                subtitle:
                    const Text('★★★★★', style: TextStyle(color: Colors.amber))),
            TextField(
                controller: title,
                decoration: const InputDecoration(
                    labelText: 'Encabezado de su reseña',
                    border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(
                controller: body,
                maxLines: 4,
                decoration: const InputDecoration(
                    labelText: 'Escribe tu reseña',
                    border: OutlineInputBorder())),
            const SizedBox(height: 14),
            PrimaryButton(
                text: 'Enviar reseña',
                onTap: () {
                  if (body.text.isEmpty) return;
                  setState(() => reviews
                      .insert(0, {'name': 'Usuario PETIT', 'text': body.text}));
                  title.clear();
                  body.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reseña publicada')));
                })
          ])));
}
