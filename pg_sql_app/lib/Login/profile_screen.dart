import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pg_sql_app/AppDrawer/app_drawer.dart';
import 'package:pg_sql_app/Data/animal.dart';
import 'package:pg_sql_app/Data/city.dart';
import 'package:pg_sql_app/Login/auth.dart';
import 'package:pg_sql_app/Login/user_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final addressController = TextEditingController();
  final animalNameController = TextEditingController();
  final passwordController = TextEditingController();
  List<City> cities = [];
  List<String> animals = [];
  String selectedCity = '';
  String selectedAnimal = '';
  User? user;

  int cityId = 0;

  @override
  void initState() {
    super.initState();
    fetchCitiesAndAnimals();
  }

  Future<void> fetchCitiesAndAnimals() async {
    // Fetch cities
    var cityResponse =
        await http.get(Uri.parse('http://localhost:8080/petShop/getAllCities'));
    List<dynamic> cityData = jsonDecode(cityResponse.body);

    setState(() {
      cities = cityData.map<City>((item) => City.fromJson(item)).toList();
      selectedCity = cities[0].name;
    });

    // Fetch animals
    var animalResponse = await http
        .get(Uri.parse('http://localhost:8080/petShop/getAllAnimals'));
    List<dynamic> animalData = jsonDecode(animalResponse.body);

    setState(() {
      animals =
          animalData.map<String>((item) => Animal.fromJson(item).name).toList();
      selectedAnimal = animals[0];
    });

    String username =
        Provider.of<AuthNotifier>(context, listen: false).username;
    var userResponse = await http.get(Uri.parse(
        'http://localhost:8080/petShop/getUserByUserName?userName=${username}'));
    print(userResponse.body);
    User userData = User.fromJson(jsonDecode(userResponse.body));
    print(userData);
    setState(() {
      user = userData;
      nameController.text = user!.name;
      surnameController.text = user!.surname;
      addressController.text = user!.address;
      passwordController.text = user!.password;
      selectedCity = user!.city.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<AuthNotifier>(context).username;
    String password = Provider.of<AuthNotifier>(context).password;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Profile Screen'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            DropdownButtonFormField(
              value: selectedCity,
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
                  selectedCity = value!;
                });
              },
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            DropdownButtonFormField(
              value: selectedAnimal,
              items: animals.map((animal) {
                return DropdownMenuItem(
                  child: Text(animal),
                  value: animal,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAnimal = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Animal Type'),
            ),
            TextFormField(
              controller: animalNameController,
              decoration: InputDecoration(labelText: 'Animal Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Send your request here
                  int selectedAnimalIndex = animals.indexOf(selectedAnimal);
                  int selectedCityIndex =
                      cities.indexWhere((city) => city.name == selectedCity);
                  // {}
                  // User user = User(
                  //     username: nameController.text,
                  //     password: '', // Add your password here
                  //     name: nameController.text,
                  //     surname: surnameController.text,
                  //     address: addressController.text,
                  //     city: City(
                  //         name: selectedCity) // Assuming animalId is an integer
                  //     );
                  var user = json.encode({
                    "userName": username,
                    "password": passwordController.text,
                    "firstName": nameController.text,
                    "lastName": surnameController.text,
                    "address": addressController.text,
                    "cityId": cities[selectedCityIndex].id,
                  });

                  print(user);
                  // Send the user to the server
                  var userUrl =
                      Uri.parse('http://localhost:8080/petShop/updateUser');
                  var response = await http.put(userUrl,
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                      },
                      body: user);

                  if (response.statusCode == 200) {
                    print('Advertisement sent successfully');
                  } else {
                    print('Failed to send advertisement');
                  }

                  var animalUrl =
                      Uri.parse('http://localhost:8080/petShop/addAnimal');
                  var response2 = await http.post(animalUrl,
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: json.encode({
                        'name': animalNameController.text,
                        'animal_id': selectedAnimalIndex,
                      }));

                  if (response.statusCode == 200) {
                    print('Advertisement sent successfully');
                  } else {
                    print('Failed to send advertisement');
                  }
                  Navigator.of(context).pushReplacementNamed('/');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
