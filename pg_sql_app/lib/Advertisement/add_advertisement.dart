import 'package:flutter/material.dart';
import 'package:pg_sql_app/Advertisement/advertisement.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAdvertisementPage extends StatefulWidget {
  static const routeName = '/add-advertisement';
  @override
  _AddAdvertisementPageState createState() => _AddAdvertisementPageState();
}

class _AddAdvertisementPageState extends State<AddAdvertisementPage> {
  final _formKey = GlobalKey<FormState>();
  String title = "Animal";
  String description = "Description";
  DateTime createdDate = DateTime.now();
  bool isActive = false;
  String selectedAnimalType = 'Kedi'; // Default value

  final animals = <String>[
    'Köpek',
    'Kedi',
    'Kuş',
    'Balık',
    'Hamster',
    'Kaplumbağa',
    'Tavşan',
    'Sincap',
    'Örümcek',
    'Koala'
  ];
  @override
  Widget build(BuildContext context) {
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
                DropdownButtonFormField<String>(
                  value: selectedAnimalType,
                  decoration: InputDecoration(labelText: 'Animal Type'),
                  items: animals.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAnimalType = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      int selectedIndex = animals.indexOf(selectedAnimalType);
                      Advertisement adv = Advertisement(
                        id: 0,
                        userId: 0,
                        title: title,
                        description: description,
                        createdDate: DateTime.now().toString(),
                        updateDate: DateTime.now().toString(),
                        isActive: isActive,
                        animalId: selectedIndex,
                      );
                      // Now you can use the values
                      print(selectedAnimalType);
                      print(title);
                      print(createdDate);
                      print(isActive);
                      var advJson = json.encode(adv.toJson());

                      // Send the Advertisement to the server
                      var url =
                          Uri.parse('http://localhost:8080/petShop/addPost');
                      var response = await http.post(url,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
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
