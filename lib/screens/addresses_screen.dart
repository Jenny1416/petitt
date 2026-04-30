import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_tag.dart';
import '../providers/app_state.dart';
import '../widgets/primary_button.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _addAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nueva Dirección', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff123516))),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _titleController,
              hintText: 'Etiqueta (Ej: Casa, Oficina)',
              prefixIcon: Icons.label_outline,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _addressController,
              hintText: 'Dirección completa',
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Guardar Dirección', 
              onTap: () {
                if (_titleController.text.isNotEmpty && _addressController.text.isNotEmpty) {
                  context.read<AppState>().addAddress(_titleController.text, _addressController.text);
                  _titleController.clear();
                  _addressController.clear();
                  Navigator.pop(context);
                }
              }
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
    final addresses = app.addresses;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Mis Direcciones', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff123516))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff123516), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: addresses.isEmpty 
        ? EmptyStateWidget(
            icon: Icons.location_off_outlined,
            title: 'Sin direcciones',
            description: 'Aún no tienes direcciones guardadas. Agrega una para facilitar tus compras.',
            buttonText: 'Agregar dirección',
            onButtonTap: _addAddress,
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: addresses.length,
            itemBuilder: (context, i) {
              final addr = addresses[i];
              bool isPrimary = addr['type'] == 'Principal';
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: isPrimary ? Border.all(color: const Color(0xff123516), width: 1.5) : null,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  onTap: () => app.setPrimaryAddress(i),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isPrimary ? const Color(0xff123516) : const Color(0xff123516).withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPrimary ? Icons.home_rounded : Icons.location_on_rounded,
                      color: isPrimary ? Colors.white : const Color(0xff123516),
                      size: 24,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(addr['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff123516))),
                      if (isPrimary) ...[
                        const SizedBox(width: 8),
                        const CustomTag(text: 'Principal', color: Color(0xff123516)),
                      ],
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(addr['address']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 22, color: Colors.redAccent),
                    onPressed: () => app.removeAddress(i),
                  ),
                ),
              );
            },
          ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: PrimaryButton(text: 'Agregar Nueva Dirección', onTap: _addAddress),
      ),
    );
  }
}
