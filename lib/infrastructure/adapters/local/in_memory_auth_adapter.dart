import '../../../domain/models/user.dart';
import '../../../domain/ports/auth_repository.dart';

class InMemoryAuthAdapter implements AuthRepository {
  final List<UserModel> _users = [
    UserModel(
        email: 'demo@petit.com',
        password: '123456',
        phone: '3001234567',
        name: 'Jennifer Lopez')
  ];
  
  UserModel? _currentUser;

  @override
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _currentUser = _users.firstWhere((u) =>
          u.email.trim().toLowerCase() == email.trim().toLowerCase() &&
          u.password == password);
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> register(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users.any((u) => u.email.toLowerCase() == user.email.toLowerCase())) {
      return false;
    }
    _users.add(user);
    _currentUser = user;
    return true;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }
}
