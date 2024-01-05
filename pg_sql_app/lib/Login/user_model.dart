import 'package:pg_sql_app/Data/city.dart';

class User {
  final String username;
  final String password;
  final String name;
  final String surname;
  final String address;
  final City city;

  User(
      {required this.username,
      required this.password,
      required this.name,
      required this.surname,
      required this.address,
      required this.city});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['userName'],
        password: json['password'],
        name: json['firstName'] ?? "",
        surname: json['lastName'] ?? "",
        address: json['address'] ?? "",
        city: City.fromJson(json['city']));
  }

  Map<String, dynamic> toJson() => {
        'userName': username,
        'password': password,
        'firstName': name,
        'lastName': surname,
        'address': address,
        'city': city.toJson()
      };
}
