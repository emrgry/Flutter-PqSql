// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pg_sql_app/Data/city.dart';
import 'package:pg_sql_app/Exception/http_exception.dart';
import 'package:pg_sql_app/Login/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'PetShop',
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.color, //accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};
  City? _selectedCity;
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _slideAnimation.addListener(() => setState(() {}));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Occured Error'),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('ok'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    // if (!_formKey.currentState!.validate()) {
    //   // Invalid!
    //   return;
    // }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      print(_authMode);
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<AuthNotifier>(context, listen: false)
            .login(_authData["email"] ?? "", _authData["password"] ?? "");
      } else {
        // Sign user up
        await Provider.of<AuthNotifier>(context, listen: false).signup(
            _authData["email"] ?? "",
            _authData["password"] ?? "",
            _selectedCity!);
      }
      Navigator.of(context).pushReplacementNamed('/advertisement-overview');
    } on HttpException catch (error) {
      var errorMessage = 'Authentication error';
      if (error.toString().contains("EMAIL_EXIST")) {
        errorMessage = "this email address is already exist";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "this is not a valid email";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "this password is too weak";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "could not find email";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "invalid password";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try later';
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedCity = '';
    Provider.of<AuthNotifier>(context, listen: false).fetchCities();
    List<City> cities = Provider.of<AuthNotifier>(context).cities;
    print(cities);
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        //height: _heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: DropdownButtonFormField(
                        value: selectedCity.isEmpty
                            ? null
                            : selectedCity, // Handle null value
                        items: cities
                            .map((city) {
                              return DropdownMenuItem(
                                child: Text(city.name),
                                value: city.name,
                              );
                            })
                            .toList()
                            .cast<DropdownMenuItem<String>>(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCity =
                                cities.firstWhere((city) => city.name == value);
                          });
                        },
                        decoration: InputDecoration(labelText: 'City'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      //contentPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor:
                          Theme.of(context).primaryTextTheme.labelLarge?.color,
                    ),
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: _switchAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
