import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pg_sql_app/Exception/http_exception.dart';

class AuthNotifier extends ChangeNotifier {
  final String _username = "";
  bool _isAuth = false;

  bool get isAuth {
    return _isAuth;
  }

  String get username => _username;

  Future<void> _authenticate(
      String username, String password, String urlSegment) async {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/posts/");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "userId": 1,
            "id": 1,
            // 'username': username,
            // 'password': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      _isAuth = true; // will check this later
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }
}
