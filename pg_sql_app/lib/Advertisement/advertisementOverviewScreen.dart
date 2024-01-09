// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pg_sql_app/Advertisement/advertisements.dart';
import 'package:pg_sql_app/Advertisement/advertisementsGrid.dart';
import 'package:pg_sql_app/Data/animal.dart';
import 'package:pg_sql_app/Data/city.dart';
import 'package:pg_sql_app/Login/auth.dart';
import 'package:pg_sql_app/Login/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../AppDrawer/app_drawer.dart';
import 'dart:convert';

enum FilterOptions {
  Dogs,
  Cats,
  Bird,
  Fish,
  Hamster,
  Turtle,
  Rabbit,
  Squirrel,
  Parrot,
  Koala,
  All
}

class AdvertisementOverviewScreen extends StatefulWidget {
  static const routeName = '/advertisement-overview';

  @override
  State<AdvertisementOverviewScreen> createState() =>
      _AdvertisementOverviewScreenState();
}

class _AdvertisementOverviewScreenState
    extends State<AdvertisementOverviewScreen> {
  // var _showFilter = "All";
  var _isInit = true;
  var _isLoading = false;
  var _data;
  var desired_text = "All";
  List<City> cities = [];
  City? selectedCity;
  List<Animal> animals = [];
  Animal? selectedAnimal;

  @override
  void initState() {
    super.initState();
    // Call fetchData initially with the "All" filter
    fetchData("All");
    fetchCities();
    fetchAnimals();
  }

  Future<void> fetchData(String filter) async {
    setState(() {
      _isLoading = true;
    });
    var url =
        'http://localhost:8080/petShop/findPostsByAnimalName?animalName=$filter';
    if (filter == "All") {
      url = 'http://localhost:8080/petShop/getAllPosts';
    }
    final response = await http.get(Uri.parse(url));
    _data = json.decode(response.body);

    Provider.of<Advertisements>(context, listen: false)
        .updateAdvertisements(_data);
    setState(() {
      _isLoading = false;
    });
  } // getUserByUserName

  Future<void> fetchCities() async {
    // Fetch cities
    var cityResponse =
        await http.get(Uri.parse('http://localhost:8080/petShop/getAllCities'));
    List<dynamic> cityData = jsonDecode(cityResponse.body);
    cities = cityData.map((item) => City.fromJson(item)).toList();
  }

  Future<void> fetchAnimals() async {
    // Fetch animals
    var animalResponse = await http
        .get(Uri.parse('http://localhost:8080/petShop/getAllAnimals'));
    List<dynamic> animalData = jsonDecode(animalResponse.body);

    setState(() {
      animals = animalData.map((item) => Animal.fromJson(item)).toList();
    });
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Products>(context).fetchAndSetProducts().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetShop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: FilterOptions.Dogs, child: Text('Only Dogs')),
              const PopupMenuItem(
                  value: FilterOptions.Cats, child: Text('Only Cats')),
              const PopupMenuItem(
                  value: FilterOptions.Bird, child: Text('Only Birds')),
              const PopupMenuItem(
                  value: FilterOptions.Fish, child: Text('Only Fishes')),
              const PopupMenuItem(
                  value: FilterOptions.Hamster, child: Text('Only Hamsters')),
              const PopupMenuItem(
                  value: FilterOptions.Turtle, child: Text('Only Turtle')),
              const PopupMenuItem(
                  value: FilterOptions.Rabbit, child: Text('Only Rabbit')),
              const PopupMenuItem(
                  value: FilterOptions.Parrot, child: Text('Only Spider')),
              const PopupMenuItem(
                  value: FilterOptions.Koala, child: Text('Only Koala')),
              const PopupMenuItem(
                  value: FilterOptions.All, child: Text('Show all')),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == FilterOptions.Dogs) {
                    // _showFilter = "Dogs";
                    fetchData("Dog");
                  } else if (selectedValue == FilterOptions.Cats) {
                    // _showFilter = "Cats";
                    fetchData("Cat");
                  } else if (selectedValue == FilterOptions.Bird) {
                    fetchData("Bird");
                  } else if (selectedValue == FilterOptions.Fish) {
                    fetchData("Fish");
                  } else if (selectedValue == FilterOptions.Hamster) {
                    fetchData("Hamster");
                  } else if (selectedValue == FilterOptions.Turtle) {
                    fetchData("Turtle");
                  } else if (selectedValue == FilterOptions.Rabbit) {
                    fetchData("Rabbit");
                  } else if (selectedValue == FilterOptions.Parrot) {
                    fetchData("Parrot");
                  } else if (selectedValue == FilterOptions.Koala) {
                    fetchData("Koala");
                  } else if (selectedValue == FilterOptions.All) {
                    // _showFilter = "All";
                    fetchData("All");
                  } else {
                    // _showFilter = "All";
                    fetchData("All");
                  }
                },
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(desired_text),
                    SizedBox(width: 50),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedCity?.name ?? 'City',
                        items: [
                          const DropdownMenuItem(
                            value: 'City',
                            child: Text('City'),
                          ),
                          ...cities
                              .map((city) {
                                return DropdownMenuItem(
                                  child: Text(city.name),
                                  value: city.name,
                                );
                              })
                              .toList()
                              .cast<DropdownMenuItem<String>>()
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (value == 'City') {
                              selectedCity = null;
                              return;
                            }
                            selectedCity =
                                cities.firstWhere((city) => city.name == value);
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedAnimal?.name ?? 'Animal',
                        items: [
                          const DropdownMenuItem(
                            value: 'Animal',
                            child: Text('Animal'),
                          ),
                          ...animals
                              .map((animal) {
                                return DropdownMenuItem(
                                  value: animal.name,
                                  child: Text(animal.name),
                                );
                              })
                              .toList()
                              .cast<DropdownMenuItem<String>>()
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (value == 'Animal') {
                              selectedAnimal = null;
                              return;
                            }
                            selectedAnimal = animals
                                .firstWhere((animal) => animal.name == value);
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        var url = '';
                        if (selectedCity != null && selectedAnimal != null) {
                          url =
                              'http://localhost:8080/petShop/findByAnimalIdAndCityId?cityId=${selectedCity!.id}&animalId=${selectedAnimal!.id}';
                        } else if (selectedAnimal != null) {
                          url =
                              'http://localhost:8080/petShop/findPostsByAnimalName?animalName=${selectedAnimal!.name}';
                        } else if (selectedCity != null) {
                          url =
                              'http://localhost:8080/petShop/findByCityId?cityId=${selectedCity!.id}';
                        } else {
                          url = 'http://localhost:8080/petShop/getAllPosts';
                        }
                        final response = await http.get(Uri.parse(url));
                        _data = json.decode(response.body);

                        Provider.of<Advertisements>(context, listen: false)
                            .updateAdvertisements(_data);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Text('Filter'),
                    ),
                  ],
                ),
                Expanded(child: AdvertisementsGrid()),
              ],
            ),
    );
  }
}



/*
DropdownButtonFormField(
          isExpanded: true,
          isDense: true,
          value: selectedCities,
          items: cities.map((city) {
            return DropdownMenuItem(
              child: Text(city.name),
              value: city.id,
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (selectedCities.contains(value)) {
                selectedCities.remove(value);
              } else {
                selectedCities.add(value as int);
              }
            });
          },
          decoration: InputDecoration(labelText: 'Cities'),
        ),
*/