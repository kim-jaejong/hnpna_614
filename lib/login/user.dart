class User {
  final String name;
  final String phoneNumber;
  final String password;
  final String address;
  final String email;

  User(
      {this.email = '',
      required this.name,
      required this.phoneNumber,
      required this.password,
      required this.address});
}
