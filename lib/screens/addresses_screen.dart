import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            const Text('Nueva Dirección', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff123516))),
            const SizedBox(height: 20),
            _buildTextField('Etiqueta (Ej: Casa, Oficina)', Icons.label_outline, _titleController),
            const SizedBox(height: 16),
            _buildTextField('Dirección completa', Icons.location_on_outlined, _addressController),
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

  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('No tienes direcciones guardadas', style: TextStyle(color: Colors.grey)),
              ],
            ),
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
                  borderRadius: BorderRadius.circular(20),
                  border: isPrimary ? Border.all(color: const Color(0xff123516), width: 1.5) : null,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  onTap: () => app.setPrimaryAddress(i),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: isPrimary ? const Color(0xff123516) : Colors.grey.shade100, shape: BoxShape.circle),
                    child: Icon(isPrimary ? Icons.home : Icons.location_on, color: isPrimary ? Colors.white : Colors.grey, size: 20),
                  ),
                  title: Row(
                    children: [
                      Text(addr['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (isPrimary) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xff123516).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                          child: const Text('Principal', style: TextStyle(color: Color(0xff123516), fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(addr['address']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
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
