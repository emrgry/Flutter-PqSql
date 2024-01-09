import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pg_sql_app/Data/city.dart';
import 'package:pg_sql_app/Exception/http_exception.dart';
import 'package:pg_sql_app/Login/user_model.dart';

class AuthNotifier extends ChangeNotifier {
  String _username = "";
  String _password = "";
  User? _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  User? get user => _user;

  List<City> cities = [];
  bool _isAuth = false;

  bool get isAuth {
    return _isAuth;
  }

  String get username => _username;
  String get password => _password;

  Future<void> _authenticate(
      String username, String password, String urlSegment) async {
    final url = Uri.parse("http://localhost:8080/petShop/checkUserLogin");
    try {
      print("username: $username");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'userName': username,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData == 1) {
        _isAuth = true;
      } else if (responseData == 2) {
        throw HttpException('INVALID_PASSWORD');
      } else if (responseData == 3) {
        throw HttpException('EMAIL_NOT_FOUND');
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> _signup(String username, String password, int id,
      String urlSegment, BuildContext ctx) async {
    final url = Uri.parse("http://localhost:8080/petShop/createUser");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'userName': username,
          'password': password,
          'cityId': id,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        await showDialog(
          context: ctx,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Trigger is Triggered'),
              content: Text('New user created: $username'),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        _isAuth = true;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchCities() async {
    // Fetch cities
    var cityResponse =
        await http.get(Uri.parse('http://localhost:8080/petShop/getAllCities'));
    List<dynamic> cityData = jsonDecode(cityResponse.body);
    cities = cityData.map((item) => City.fromJson(item)).toList();
  }

  Future<void> login(String email, String password) async {
    _username = email;
    _password = password;
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(
      String email, String password, City city, BuildContext ctx) async {
    _username = email;
    _password = password;
    return _signup(email, password, city.id ?? 1, 'signUp', ctx);
  }
}
