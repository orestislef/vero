import 'package:vero/enums.dart';

class UsersResponse {
  final String message;
  final List<User> users;

  UsersResponse({required this.message, required this.users});

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    List<User> users = [];
    if (json['users'] != null) {
      json['users'].forEach((user) {
        users.add(User.fromJson(user));
      });
    }
    return UsersResponse(message: json['message'], users: users);
  }
}

class User {
  late int id;
  late String username;
  late String password;
  late String token;
  late UserStatus status;
  late DateTime createdAt;

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.token,
      required this.status,
      required this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        password: json['password'],
        token: json['token'],
        status: UserStatusExtension.fromString(json['status']),
        createdAt: DateTime.parse(json['created_at']));
  }
}
