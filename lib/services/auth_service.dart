import '../models/user_model.dart';

class AuthService {
  final List<UserModel> _users = [
    UserModel(
        email: 'demo@petit.com',
        password: '123456',
        phone: '3001234567',
        name: 'Jennifer Lopez')
  ];
  UserModel? currentUser;
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      currentUser = _users.firstWhere((u) =>
          u.email.trim().toLowerCase() == email.trim().toLowerCase() &&
          u.password == password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password, String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase()))
      return false;
    currentUser = UserModel(email: email, password: password, phone: phone);
    _users.add(currentUser!);
    return true;
  }

  Future<bool> sendReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _users.any((u) => u.email.toLowerCase() == email.toLowerCase());
  }

  Future<void> updatePassword(String email, String newPass) async {
    for (final u in _users) {
      if (u.email.toLowerCase() == email.toLowerCase()) u.password = newPass;
    }
  }
}
