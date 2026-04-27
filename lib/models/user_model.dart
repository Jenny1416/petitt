class UserModel {
  String email, password, phone, name;
  UserModel(
      {required this.email,
      required this.password,
      required this.phone,
      this.name = 'Usuario PETIT'});
}
