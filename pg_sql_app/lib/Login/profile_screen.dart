import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pg_sql_app/Login/user_model.dart';

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
  List<String> cities = [];
  List<String> animals = [];
  String selectedCity = '';
  String selectedAnimal = '';

  @override
  void initState() {
    super.initState();
    fetchCitiesAndAnimals();
  }

  Future<void> fetchCitiesAndAnimals() async {
    // Fetch cities
    var cityResponse = await http.get(Uri.parse(''));
    var cityData = jsonDecode(cityResponse.body);
    setState(() {
      cities = cityData.map<String>((item) => item['name']).toList();
      selectedCity = cities[0];
    });

    // Fetch animals
    var animalResponse = await http.get(Uri.parse(''));
    var animalData = jsonDecode(animalResponse.body);
    setState(() {
      animals = animalData.map<String>((item) => item['name']).toList();
      selectedAnimal = animals[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            DropdownButtonFormField(
              value: selectedCity,
              items: cities.map((city) {
                return DropdownMenuItem(
                  child: Text(city),
                  value: city,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                });
              },
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextFormField(
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
                  int selectedCityIndex = cities.indexOf(selectedCity);
                  User user = User(
                      username: nameController.text,
                      password: '', // Add your password here
                      name: nameController.text,
                      surname: surnameController.text,
                      address: addressController.text,
                      city: selectedCityIndex // Assuming animalId is an integer
                      );

                  var advJson = json.encode(user.toJson());

                  // Send the user to the server
                  var userUrl =
                      Uri.parse('http://localhost:8080/petShop/addUser');
                  var response = await http.post(userUrl,
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: advJson);

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
