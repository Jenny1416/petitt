import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/ports/address_repository.dart';

class SupabaseAddressAdapter implements AddressRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Map<String, String>>> getAddresses(String userId) async {
    try {
      final response = await _client
          .from('addresses')
          .select()
          .eq('user_id', userId);

      return (response as List).map((json) => {
        'id': json['id'].toString(),
        'title': json['title']?.toString() ?? '',
        'address': json['address_line']?.toString() ?? '',
        'type': json['is_default'] == true ? 'Principal' : 'Secundaria',
      }).toList();
    } catch (e) {
      print('Error al obtener direcciones de Supabase: $e');
      return [];
    }
  }

  @override
  Future<void> addAddress(String userId, String title, String addressLine) async {
    try {
      await _client.from('addresses').insert({
        'user_id': userId,
        'title': title,
        'address_line': addressLine,
        'is_default': false,
      });
    } catch (e) {
      print('Error al añadir dirección en Supabase: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      await _client.from('addresses').delete().eq('id', addressId);
    } catch (e) {
      print('Error al eliminar dirección en Supabase: $e');
      rethrow;
    }
  }

  @override
  Future<void> setPrimaryAddress(String userId, String addressId) async {
    try {
      // Primero ponemos todas en false para ese usuario
      await _client
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId);
      
      // Luego ponemos la elegida en true
      await _client
          .from('addresses')
          .update({'is_default': true})
          .eq('id', addressId);
    } catch (e) {
      print('Error al establecer dirección principal en Supabase: $e');
      rethrow;
    }
  }
}
