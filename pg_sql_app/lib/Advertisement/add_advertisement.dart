import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pg_sql_app/Advertisement/advertisement.dart';
import 'package:http/http.dart' as http;
import 'package:pg_sql_app/Data/animal.dart';
import 'package:pg_sql_app/Data/city.dart';
import 'package:pg_sql_app/Login/auth.dart';
import 'dart:convert';

import 'package:pg_sql_app/Login/user_model.dart';
import 'package:provider/provider.dart';

class AddAdvertisementPage extends StatefulWidget {
  static const routeName = '/add-advertisement';
  @override
  _AddAdvertisementPageState createState() => _AddAdvertisementPageState();
}

class _AddAdvertisementPageState extends State<AddAdvertisementPage> {
  final _formKey = GlobalKey<FormState>();
  String title = "Animal";
  String description = "Description";
  String image_url = "";
  DateTime createdDate = DateTime.now();
  bool isActive = false;
  String selectedAnimal = ''; // Default value
  List<String> animals = [];

  @override
  void initState() {
    super.initState();
    fetchCitiesAndAnimals();
  }

  Future<void> fetchCitiesAndAnimals() async {
    // Fetch animals
    var animalResponse = await http
        .get(Uri.parse('http://localhost:8080/petShop/getAllAnimals'));
    List<dynamic> animalData = jsonDecode(animalResponse.body);

    setState(() {
      animals =
          animalData.map<String>((item) => Animal.fromJson(item).name).toList();
      selectedAnimal = animals[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<AuthNotifier>(context).username;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Advertisement'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                SizedBox(height: 16),
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
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onSaved: (value) {
                    image_url = value ??
                        'https://raw.githubusercontent.com/emrgry/petDB/main/download.jpeg';
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      int selectedIndex = animals.indexOf(selectedAnimal);
                      Advertisement adv = Advertisement(
                        name: username,
                        title: title,
                        description: description,
                        createdDate:
                            DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        updateDate:
                            DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        isActive: isActive,
                        animalName: selectedAnimal,
                        imageUrl: image_url,
                      );
                      // Now you can use the values
                      var advJson = json.encode(adv.toJson());
                      // Send the Advertisement to the server
                      var url =
                          Uri.parse('http://localhost:8080/petShop/createPost');
                      var response = await http.post(url,
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                          },
                          body: advJson);

                      if (response.statusCode == 200) {
                        print('Advertisement sent successfully');
                      } else {
                        print('Failed to send advertisement');
                      }
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
