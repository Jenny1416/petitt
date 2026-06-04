abstract class AddressRepository {
  Future<List<Map<String, String>>> getAddresses(String userId);
  Future<void> addAddress(String userId, String title, String addressLine);
  Future<void> deleteAddress(String addressId);
  Future<void> setPrimaryAddress(String userId, String addressId);
}
